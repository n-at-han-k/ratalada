# frozen_string_literal: true

# The index page IS the API's own documentation: the forked swagger-ui under
# frontend/, pointed at the document `bin/schema` writes out of the specs.
#
# This file is not generated. Everything else under app/ is written from the
# document on every run -- this one is copied, like _layout.rb.
#
# No `__END__` here: spec/pages_spec.rb evals what follows one in every page as
# openapi_ruby's DSL, and this page declares nothing -- it is not in the
# document it serves.

DOCUMENT_PATH = File.expand_path("../openapi/public_api.yaml", __dir__)

helpers do
  # The document the specs declared. Until `bin/schema` has run there is none,
  # and swagger-ui is handed nothing rather than a broken spec.
  def document
    return {} unless File.exist?(DOCUMENT_PATH)

    @document ||= YAML.safe_load_file(DOCUMENT_PATH, aliases: true)
  end
end

template :swagger do
  <<~ERB
    <!doctype html>
    <html>
      <head>
        <meta charset=utf-8>
        <meta name=viewport content="width=device-width,initial-scale=1">
        <title><%= document.dig("info", "title") || "API" %></title>
        <%= vite_client_tag %>
        <%= vite_react_refresh_tag %>
        <%= vite_javascript_tag "swagger.tsx" %>
      </head>
      <body>
        <!-- Embedded, not fetched: the document is already here, and a fetch
             would be a second route the document never declared. -->
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
