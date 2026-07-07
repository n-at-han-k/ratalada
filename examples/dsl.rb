# This file exists to experiment with DSL ideas


# ----------------------------------------------------------

require "ratalada/puma"

Server.run do |env|
  case env
  when ["GET", "/"]   then -> (env) { [200, {}, "ok"] }
  when ["GET", "/up"] then -> (env) { [200, {}, "ok"] }
  end
end

# ----------------------------------------------------------

require "ratalada/falcon"

Server.run do |env|
  case env
  when ["GET", "/"]   then -> (env) { [200, {}, "ok"] }
  when ["GET", "/up"] then -> (env) { [200, {}, "ok"] }
  end
end

# ----------------------------------------------------------

require "ratalada/falcon"
require "ratalada/sinatra"

Server.run do |env|
  get "/" do
    "ok"
  end

  get "up" do
    "ok
  end
end
