# frozen_string_literal: true

get "/" do
  content_type("text/plain")
  "User-agent: *\nAllow: /\n"
end
