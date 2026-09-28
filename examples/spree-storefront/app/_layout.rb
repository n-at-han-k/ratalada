# frozen_string_literal: true

# A layout is evaluated into every route file below it, so this is where the
# whole app's Sinatra setup lives.
#
# session[:_inertia_errors] is where the render helpers keep validation errors
# between the redirect and the page that shows them.
enable :sessions

helpers Ratalada::Contrib::Vite::TagHelpers
helpers Ratalada::Contrib::Inertia::Helpers

# The page shell. `inertia` renders this once per full page load; every
# navigation after it is the client's, off the page object below.
template :layout do
  <<~ERB
    <!doctype html>
    <html>
      <head>
        <meta charset=utf-8>
        <meta name=viewport content="width=device-width,initial-scale=1">
        <title>Store</title>
        <%= vite_client_tag %>
        <%= vite_react_refresh_tag %>
        <%= vite_javascript_tag "application.tsx" %>
      </head>
      <body>
        <!-- The Inertia page object, in the script element @inertiajs/* v3
             reads it from (the data-page attribute form is v2). The client
             mounts the component named in it: the TSX after __END__ in that
             app/*.rb. -->
        <script data-page="app" type="application/json"><%= JSON.generate(@page).gsub("/", "\\\\/") %></script>
        <div id="app"></div>
      </body>
    </html>
  ERB
end

__END__

export { default } from "@/layouts/app-layout"
