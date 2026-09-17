# frozen_string_literal: true

# Every OmniAuth failure lands here: server.rb points on_failure at this path
# rather than letting the gem render its own page.
get "/" do
  message = params["message"].to_s
  page_errors(
    auth_key: message == "invalid_credentials" ? "Those credentials are not right" : message,
  )
  redirect("/login", 303)
end
