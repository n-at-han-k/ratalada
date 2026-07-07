# frozen_string_literal: true

# Serve a brute agent over HTTP.
#
#   curl -d 'Say hi' http://localhost:9292/ask

require "ratalada/falcon"
require "ratalada/sinatra"
require "brute"
require "ruby_llm"

RubyLLM.configure do |config|
  config.ollama_api_base = "http://localhost:11434/v1"
end

Server.run do
  get "/ask" do
    Brute.agent.run do |env|
      RubyLLM.chat(model: "llama3.2", provider: :ollama).then do |chat|
        chat.ask(env[:messages].last.content).content.then do |response|
          env[:messages].assistant(response)
        end
      end
    end.then do |agent|
      agent.start(request.body.read)[:messages].last.content
    end
  end
end
