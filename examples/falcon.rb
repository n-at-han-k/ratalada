# frozen_string_literal: true

# Run:  bundle exec ruby examples/falcon.rb
# Try:  curl http://localhost:9292/
#       curl http://localhost:9292/up
#       curl "http://localhost:9292/greet?name=world"

require "ratalada/falcon"

Server.run do |request|
  case request
  in ["GET", "/"]     then "hello from falcon\n"
  in ["GET", "/up"]   then "ok\n"
  in ["GET", "/greet"] then ->(req) { "hello #{req.query.delete_prefix("name=")}\n" }
  end
end
