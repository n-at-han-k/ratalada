# frozen_string_literal: true

# An MCP (Model Context Protocol) server over Streamable HTTP.
#
# The MCP Ruby SDK's transport is a plain rack app, and its SSE responses are
# rack streaming bodies — on falcon every open stream is just a parked fiber,
# so tools that sleep or wait on IO don't block other requests.
#
# Run:  ruby examples/mcp.rb
#
# Try:
#   # initialize a session — the mcp-session-id response header:
#   SID=$(curl -si http://localhost:9292/mcp \
#     -H 'content-type: application/json' -H 'accept: application/json, text/event-stream' \
#     -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"curl","version":"0"}}}' \
#     | grep -i '^mcp-session-id:' | tr -d '\r' | awk '{print $2}')
#
#   curl -s http://localhost:9292/mcp \
#     -H 'content-type: application/json' -H 'accept: application/json, text/event-stream' \
#     -H "mcp-session-id: $SID" -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'
#
#   # call the slow tool — progress notifications stream back before the result:
#   curl -sN http://localhost:9292/mcp \
#     -H 'content-type: application/json' -H 'accept: application/json, text/event-stream' \
#     -H "mcp-session-id: $SID" \
#     -d '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"slow_counter","arguments":{"count":5},"_meta":{"progressToken":"t"}}}'

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "ratalada", path: File.expand_path("..", __dir__)
  gem "falcon"
  gem "mcp"
  gem "rack"
end

require "ratalada/falcon"
require "mcp"
require "mcp/server/transports/streamable_http_transport"

class SlowCounterTool < MCP::Tool
  tool_name "slow_counter"
  description "Counts to N, one second per step, reporting progress over SSE"
  input_schema(properties: { count: { type: "integer" } }, required: ["count"])

  class << self
    def call(count:, server_context:)
      count.times do |i|
        sleep(1) # parks this request's fiber; other requests keep flowing
        server_context.report_progress(i + 1, total: count, message: "step #{i + 1}")
      end
      MCP::Tool::Response.new([{ type: "text", text: "counted to #{count}" }])
    end
  end
end

class TimeTool < MCP::Tool
  tool_name "time"
  description "Returns the current server time"
  input_schema(properties: {}, required: [])

  class << self
    def call(server_context:)
      MCP::Tool::Response.new([{ type: "text", text: Time.now.iso8601 }])
    end
  end
end

Server.run do |request|
  @transport ||= MCP::Server::Transports::StreamableHTTPTransport.new(
    MCP::Server.new(name: "ratalada_mcp", version: "0.1.0", tools: [SlowCounterTool, TimeTool]),
  )

  case request
  in [_, "/mcp"]  then @transport.call(request.env)
  in ["GET", "/"] then "MCP: POST/GET/DELETE /mcp\n"
  end
end
