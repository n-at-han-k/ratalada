# frozen_string_literal: true

# The whole app: one page, which is the document.
#
# The document is embedded in the page rather than fetched. swagger-ui will
# happily take a `url:` and go and get one, but then the document is a second
# route this app would have to serve, and it is already on disk here.

require "json"
require "yaml"

helpers do
  # JSON is YAML, so one reader covers .json, .yaml and .yml.
  def document = @document ||= YAML.safe_load_file(SCHEMA, aliases: true)

  def title = document.dig("info", "title") || "API"
end

template :swagger do
  <<~ERB
    <!doctype html>
    <html>
      <head>
        <meta charset=utf-8>
        <meta name=viewport content="width=device-width,initial-scale=1">
        <title><%= title %></title>
        <%= vite_client_tag %>
        <%= vite_react_refresh_tag %>
        <%= vite_javascript_tag "swagger.tsx" %>
      </head>
      <body>
        <script id="swagger-document" type="application/json"><%= JSON.generate(document).gsub("/", "\\\\/") %></script>
        <div id="swagger"></div>
      </body>
    </html>
  ERB
end

get "/" do
  content_type(:html)
  erb(:swagger, layout: false)
end
