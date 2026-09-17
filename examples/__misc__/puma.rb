# frozen_string_literal: true

# Run:  bundle exec ruby examples/puma.rb
# Try:  curl http://localhost:9292/
#       curl http://localhost:9292/up
#       curl -d "hello" http://localhost:9292/echo

require "ratalada/puma"

Server.run do |request|
  case request
  in ["GET", "/"]      then "hello from puma\n"
  in ["GET", "/up"]    then "ok\n"
  in ["POST", "/echo"] then ->(req) { [200, { "content-type" => "text/plain" }, req.body] }
  end
end
