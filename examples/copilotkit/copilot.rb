# frozen_string_literal: true

require "ag_ui"
require "open_router"
# THE HTTP ADAPTER, and it is the app's call to make. open_router is Faraday,
# whose default adapter is Net::HTTP -- a blocking call that parks falcon's
# reactor THREAD rather than this request's fiber, so one completion would
# stall every other open stream.
require "async/http/faraday/default"

# The house terminal (vendored -- see the file's header). ag-ui ships one on
# ruby_llm, which this house does not use.
require_relative "lib/ag_ui/terminals/open_router"

# THE COPILOTKIT RUNTIME, IN THIS PROCESS.
#
# CopilotKit's own runtime is a Node service, but the protocol between it and
# the React client -- AG-UI: an SSE event stream and client-tool round-trips --
# has a Ruby server implementation in the ag-ui gem. So a ratalada app can be
# the runtime itself: no sidecar, no second process, one deploy.
#
# Two halves, and this file is the whole server one:
#
#   Mount   rack middleware (see server.rb). /api/copilotkit is handed to the
#           AG-UI app, which serves the multi-route surface the client expects
#           (/info, /agent/:id/run, /connect, /stop). Everything else falls
#           through to the router. The run endpoint's SSE stream passes through
#           as-is, because this is one rack app in front of another.
#
#   turn    one pass of the model, assembled as a plain brute pipeline: system
#           prompt + the client's context, the tool loop, a step cap, and the
#           OpenRouter terminal at the bottom.
#
# THE TOOLS LIVE IN THE BROWSER. ToolRouter advertises whatever the page
# registered with useFrontendTool (frontend/components/copilot-chat.tsx) and
# halts the pipeline when the model calls one; the browser runs the handler and
# posts the result back into the next turn. So the agent acts through the same
# code the UI does, and the server needs no copy of it.
module Copilot
  MOUNT_PATH     = "/api/copilotkit"
  # OpenRouter's own naming (dotted), since that is who resolves it.
  MODEL          = ENV.fetch("COPILOT_MODEL", "anthropic/claude-sonnet-4.5")
  MAX_ITERATIONS = 10

  SYSTEM_PROMPT = <<~PROMPT.strip
    You are the assistant embedded in a ratalada example app. The page shares
    its current state with you as context, and gives you tools to change it.

    Rules:
    - To change anything the user asks for, CALL the tool. Never claim you added,
      removed or completed something unless a tool call returned saying you did.
    - You cannot see the page -- only the context it shares. If the context does
      not contain something, say so instead of inventing it.
    - Keep answers to a sentence or two.
  PROMPT

  # No key, no copilot: read per request so a process started before the key was
  # exported picks it up, and shared with the page (see app/_layout.rb) so the
  # launcher is absent rather than opening a chat that fails on first message.
  def self.enabled? = !api_key.to_s.strip.empty?

  # The units under ~/agents read this from CREDENTIALS_DIRECTORY; an example
  # run by hand reads the environment.
  def self.api_key = ENV["OPENROUTER_API_KEY"]

  def self.app
    @app ||= begin
      OpenRouter.configure { |config| config.access_token = api_key }
      terminal = AgUi::Terminals::OpenRouter.new(model: MODEL)

      AgUi.agent(agent_id: "default") { |env| run(env, terminal) }
    end
  end

  # One run: RUN_STARTED, the turn, RUN_FINISHED -- or RUN_ERROR, which puts the
  # failure in the chat instead of tearing down the stream.
  def self.run(env, terminal)
    input = env["ag_ui.input"]

    env["ag_ui.stream"].open(thread_id: input.thread_id, run_id: input.run_id) do |stream|
      stream.run_started
      # The bridge subscribes the AG-UI event vocabulary onto the pipeline's
      # hooks and hands the pipeline back, so text and tool calls reach the
      # browser as they are produced rather than at the end of the turn.
      AgUi::EventBridge
        .new(stream)
        .subscribe(turn(input, terminal))
        .start(AgUi::Messages.to_brute(input.messages))
      stream.run_finished
    rescue StandardError => e
      warn("[copilot] run failed: #{e.class}: #{e.message}")
      stream.run_error(message: e.message, code: e.class.name)
    end
  end

  # Rebuilt per run: the context and the tool list are the page's, and they
  # change as the user moves around and as the page's state changes.
  def self.turn(input, terminal)
    Brute.agent
         .use(AgUi::Middleware::SystemPrompt, prompt: SYSTEM_PROMPT, context: input.context)
         .use(Brute::Middleware::Loop::ToolResult)
         .use(Brute::Middleware::MaxIterations, max_iterations: MAX_ITERATIONS)
         .use(AgUi::Middleware::ToolRouter, tools: input.tools, server_tools: [])
         .run(terminal)
  end

  class Mount
    NOT_CONFIGURED = [
      503,
      { "content-type" => "application/json" },
      ['{"error":"copilot is not configured: set OPENROUTER_API_KEY"}'],
    ].freeze

    def initialize(app) = @app = app

    def call(env)
      path = env["PATH_INFO"].to_s

      if !copilot_path?(path)
        @app.call(env)
      elsif !Copilot.enabled?
        NOT_CONFIGURED.dup
      else
        # The prefix moves to SCRIPT_NAME: the runtime routes on the trailing
        # segments and reads an EMPTY path as a bare run, so leaving the prefix
        # on PATH_INFO would make every request look like one.
        Copilot.app.call(
          env.merge(
            "SCRIPT_NAME" => "#{env["SCRIPT_NAME"]}#{MOUNT_PATH}",
            "PATH_INFO"   => path.delete_prefix(MOUNT_PATH),
          ),
        )
      end
    end

    private

      # On a segment boundary, so /api/copilotkitten is the router's, not ours.
      def copilot_path?(path)
        path == MOUNT_PATH || path.start_with?("#{MOUNT_PATH}/")
      end
  end
end
