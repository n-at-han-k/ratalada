# frozen_string_literal: true

# VENDORED, VERBATIM, from ~/agents/lib/ag_ui/terminals/open_router.rb (the
# `agents` gem is not published). Keep it in step with that copy; it belongs
# upstream in the ag-ui gem, as its own comment says.
#

require "securerandom"
require "json"

module AgUi
  module Terminals
    # A STREAMING AG-UI terminal on OpenRouter.
    #
    # ag-ui ships one terminal, on ruby_llm, which this house does not use.
    # Brute has an OpenRouter completion but it does not stream: it calls
    # `client.complete(messages, options)` and appends the finished message, so
    # a chat bubble would show nothing until the whole reply landed. The gem is
    # not the limitation — `complete` takes a `stream:` proc — so this drives it
    # directly and turns the deltas into the AG-UI vocabulary the EventBridge
    # translates onto the wire.
    #
    # Lives here rather than in the gem because it is wanted now; it belongs
    # upstream as AgUi::Terminals::OpenRouter once it has earned its keep.
    #
    #   terminal = AgUi::Terminals::OpenRouter.new(model: "anthropic/claude-sonnet-4.5")
    #   agent = Brute.agent.use(...).run(terminal)
    class OpenRouter
      def initialize(model:, client: nil, **options)
        begin
          require "open_router"
        rescue LoadError
          raise LoadError, "#{self.class} needs the 'open_router_enhanced' gem."
        end

        @model = model
        @client = client
        @options = options
      end

      def call(env)
        emitter = TurnEmitter.new(env)
        turn = Turn.new

        client.complete(
          Brute::MessageTransport::OpenRouter.dump_all(env[:messages], model: @model),
          completion_options(env),
          stream: ->(chunk) { consume(chunk, emitter, turn) },
        )

        emitter.finish
        env[:messages] << turn.message
        env
      end

      def to_proc = method(:call).to_proc

      private

        def client
          @client ||= ::OpenRouter::Client.new
        end

        # The run's CLIENT tools, advertised so the model can call them but
        # never executed here: ToolRouter ends the run on a client call and the
        # browser runs it, carrying the result back in the next run's history.
        def completion_options(env)
          tools = Array(env[:tools]).map do |definition|
            if definition.respond_to?(:to_h)
              declaration = definition.to_h
            else
              declaration = definition
            end
            {
              type:     "function",
              function: {
                name:        declaration["name"],
                description: declaration["description"].to_s,
                parameters:  declaration["parameters"] || { "type" => "object" },
              },
            }
          end

          options = { model: @model, **@options }
          if tools.any?
            options[:tools] = tools
          end
          options
        end

        # One streamed chunk. Content and reasoning go straight out as deltas;
        # tool calls are accumulated, because a call arrives split across chunks
        # and is only whole at the end of the turn.
        def consume(chunk, emitter, turn)
          delta = chunk.dig("choices", 0, "delta")
          if delta
            reasoning = delta["reasoning"]
            if reasoning
              emitter.thinking_delta(reasoning.to_s)
            end

            content = delta["content"]
            if content
              emitter.text_delta(content.to_s)
            end

            calls = delta["tool_calls"]
            if calls
              turn.absorb_tool_calls(calls)
            end

            turn.absorb_content(content)
          end
        end

        # The assistant message being assembled from the stream. OpenRouter
        # sends a tool call in pieces keyed by `index` — the id and name once,
        # the arguments as a JSON string a fragment at a time — so they are
        # collected by index and only parsed when the turn is over.
        class Turn
          def initialize
            @content = +""
            @tool_calls = {}
          end

          def absorb_content(content)
            unless content.nil?
              @content << content.to_s
            end
          end

          def absorb_tool_calls(calls)
            calls.each do |call|
              index = call["index"] || 0
              slot = (@tool_calls[index] ||= { "id" => nil, "name" => nil, "arguments" => +"" })
              slot["id"] ||= call["id"]
              function = call["function"] || {}
              slot["name"] ||= function["name"]
              slot["arguments"] << function["arguments"].to_s
            end
          end

          def message
            if @tool_calls.empty?
              Brute::Message.new(role: :assistant, content: @content)
            else
              Brute::Message.new(
                role:       :assistant,
                content:    @content,
                tool_calls: @tool_calls.keys.sort.map { |index| tool_call(@tool_calls[index]) },
              )
            end
          end

          private

            def tool_call(slot)
              {
                id:        slot["id"] || SecureRandom.uuid,
                name:      slot["name"].to_s,
                arguments: parse_arguments(slot["arguments"]),
              }
            end

            # A model can emit arguments that never parse. Handing the tool an
            # empty hash lets the run finish and the tool report what it got,
            # which reaches the user; raising here would lose the whole turn.
            def parse_arguments(json)
              if json.to_s.empty?
                {}
              else
                begin
                  parsed = JSON.parse(json)
                  parsed.is_a?(Hash) ? parsed : {}
                rescue JSON::ParserError
                  {}
                end
              end
            end
        end

        # Emits the turn's reasoning and text phases lazily: nothing opens until
        # its first non-empty delta, so a tool-call-only turn produces no empty
        # bubble, and reasoning closes as soon as text begins because providers
        # stream thinking strictly before the answer.
        class TurnEmitter
          def initialize(env)
            @env = env
            @text_id = SecureRandom.uuid
            @reasoning_id = SecureRandom.uuid
            @text_started = false
            @reasoning_open = false
          end

          def thinking_delta(text)
            unless text.empty?
              open_reasoning
              @env.emit(:reasoning_message_content, { message_id: @reasoning_id, delta: text })
            end
          end

          def text_delta(text)
            unless text.empty?
              close_reasoning
              unless @text_started
                @env.emit(:text_message_start, { message_id: @text_id })
                @text_started = true
              end
              @env.emit(:text_message_content, { message_id: @text_id, delta: text })
            end
          end

          def finish
            close_reasoning
            if @text_started
              @env.emit(:text_message_end, { message_id: @text_id })
            end
          end

          private

            def open_reasoning
              unless @reasoning_open
                @env.emit(:reasoning_start, { message_id: @reasoning_id })
                @env.emit(:reasoning_message_start, { message_id: @reasoning_id })
                @reasoning_open = true
              end
            end

            def close_reasoning
              if @reasoning_open
                @env.emit(:reasoning_message_end, { message_id: @reasoning_id })
                @env.emit(:reasoning_end, { message_id: @reasoning_id })
                @reasoning_open = false
              end
            end
        end
    end
  end
end

__END__

describe "AgUi::Terminals::OpenRouter" do
  # The production file assumes its host has already loaded these; a spec run
  # loads the file on its own, so it says so.
  require "bundler/setup"
  require "brute"
  require "brute/hooks"
  require "open_router"

  # A client that replays canned stream chunks the way OpenRouter would, so the
  # terminal is exercised without a network or a key.
  fake_client = lambda do |chunks|
    Object.new.tap do |double|
      double.define_singleton_method(:seen) { @seen }
      double.define_singleton_method(:complete) do |messages, options, stream:|
        @seen = { messages: messages, options: options }
        chunks.each { |chunk| stream.call(chunk) }
        nil
      end
    end
  end

  delta = lambda do |**fields|
    { "choices" => [{ "delta" => fields.transform_keys(&:to_s) }] }
  end

  # Records what reached the wire, in order, the way the EventBridge would.
  TURN_EVENTS = %i[
    text_message_start text_message_content text_message_end
    reasoning_start reasoning_message_start reasoning_message_content
    reasoning_message_end reasoning_end
  ].freeze

  traced = lambda do |into, **env|
    hooks = Brute::Hooks::Registry.new
    TURN_EVENTS.each do |event|
      hooks.on(event) { |_e, data, _t| into << { type: event, data: data } }
    end
    Brute::Hooks::Trace.new({ messages: Brute.log, **env }, hooks: hooks)
  end

  it "streams text deltas and appends the assistant message" do
    client = fake_client.([delta.(content: "Hel"), delta.(content: "lo")])
    events = []
    env = traced.(events)
    env[:messages].user("hi")

    AgUi::Terminals::OpenRouter.new(model: "anthropic/claude-sonnet-4.5", client: client).call(env)

    events.map { |e| e[:type] }.should == %i[
      text_message_start text_message_content text_message_content text_message_end
    ]
    events[1][:data][:delta].should == "Hel"
    env[:messages].last.role.should == :assistant
    env[:messages].last.content.should == "Hello"
  end

  it "opens a reasoning phase and closes it before any text" do
    client = fake_client.([
      delta.(reasoning: "thinking"),
      delta.(content: "answer"),
    ])
    events = []
    env = traced.(events)
    env[:messages].user("why?")

    AgUi::Terminals::OpenRouter.new(model: "m", client: client).call(env)

    events.map { |e| e[:type] }.should == %i[
      reasoning_start reasoning_message_start reasoning_message_content
      reasoning_message_end reasoning_end
      text_message_start text_message_content text_message_end
    ]
  end

  it "reassembles a tool call split across chunks" do
    client = fake_client.([
      delta.(tool_calls: [{ "index" => 0, "id" => "tc1", "function" => { "name" => "navigate" } }]),
      delta.(tool_calls: [{ "index" => 0, "function" => { "arguments" => '{"path":' } }]),
      delta.(tool_calls: [{ "index" => 0, "function" => { "arguments" => '"/data"}' } }]),
    ])
    events = []
    env = traced.(events)

    AgUi::Terminals::OpenRouter.new(model: "m", client: client).call(env)

    # A tool-only turn opens no text phase.
    events.should == []

    message = env[:messages].last
    message.tool_call?.should.be.true
    message.tool_calls.first.id.should == "tc1"
    message.tool_calls.first.name.should == "navigate"
    message.tool_calls.first.arguments.should == { "path" => "/data" }
  end

  it "survives arguments that never parse rather than losing the turn" do
    client = fake_client.([
      delta.(tool_calls: [{ "index" => 0, "id" => "tc1",
                            "function" => { "name" => "navigate", "arguments" => "{not json" } }]),
    ])
    env = traced.([])

    AgUi::Terminals::OpenRouter.new(model: "m", client: client).call(env)

    env[:messages].last.tool_calls.first.arguments.should == {}
  end

  it "advertises the run's client tools to the model" do
    client = fake_client.([delta.(content: "ok")])
    env = traced.([], tools: [{ "name" => "navigate", "description" => "Go", "parameters" => { "type" => "object" } }])

    AgUi::Terminals::OpenRouter.new(model: "m", client: client).call(env)

    tools = client.seen[:options][:tools]
    tools.length.should == 1
    tools.first[:function][:name].should == "navigate"
    client.seen[:options][:model].should == "m"
  end

  it "sends no tools key when the run declares none" do
    client = fake_client.([delta.(content: "ok")])
    AgUi::Terminals::OpenRouter.new(model: "m", client: client).call(traced.([]))

    client.seen[:options].key?(:tools).should.be.false
  end
end
