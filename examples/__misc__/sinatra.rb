# frozen_string_literal: true

# Run:  bundle exec ruby examples/sinatra.rb
# Try:  curl http://localhost:9292/
#       curl http://localhost:9292/up
#       curl http://localhost:9292/greet/world

require "ratalada/falcon"
require "ratalada/sinatra"

Server.run do
  get "/" do
    "hello from sinatra on falcon\n"
  end

  get "/up" do
    "ok\n"
  end

  get "/greet/:name" do
    "hello #{params[:name]}\n"
  end
end
