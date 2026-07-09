# frozen_string_literal: true

# Run:  bundle exec ruby examples/grape.rb
# Try:  curl http://localhost:9292/
#       curl http://localhost:9292/up
#       curl http://localhost:9292/greet/world

require "ratalada/falcon"
require "ratalada/grape"

Server.run do
  format :txt

  get "/" do
    "hello from grape on falcon\n"
  end

  get "/up" do
    "ok\n"
  end

  get "/greet/:name" do
    "hello #{params[:name]}\n"
  end
end
