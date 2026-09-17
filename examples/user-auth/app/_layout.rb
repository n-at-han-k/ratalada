# frozen_string_literal: true

# A layout is evaluated into every route file below it, so this is where the
# whole app's Sinatra setup lives.
#
# There is no `enable :sessions` here: the session is Rack::Session::Cookie in
# server.rb, mounted above OmniAuth, which needs one before it runs.
helpers Ratalada::Contrib::Vite::TagHelpers
helpers Ratalada::Contrib::Inertia::Helpers

helpers do
  def current_user
    @current_user ||= session[:account_id] && Account[session[:account_id]]
  end

  def sign_in(id)
    # A fresh session id for a fresh login: anything an anonymous visitor put
    # in the session must not carry over into an authenticated one.
    session.clear
    session[:account_id] = Integer(id)
    Account.where(id: session[:account_id]).update(last_login_at: Time.now.to_i)
  end

  def sign_out = session.clear

  def require_user!
    redirect("/login?return_to=#{CGI.escape(request.fullpath)}", 303) unless current_user
  end

  # Whoever owns a Google-verified email address, creating the account on
  # first sight. Shared by both Google paths — the redirect callback and One
  # Tap — which make the identical trust decision and differ only in how the
  # claims arrive.
  #
  # The account is keyed on EMAIL, which is only safe because every caller has
  # checked `email_verified` FIRST: without that, anyone who can set an
  # unverified address on a Google account could claim someone else's login
  # here. Do not call this with an unverified address.
  #
  # The new account never learns its random password: Google is how it signs
  # in, and a password reset is how its owner would take up the credentials
  # path later. Answers nil if the account could not be created.
  def google_account(email)
    account = Account.locate(email: email) ||
              Account.new(email: email).tap { it.password = SecureRandom.hex(32) }.tap(&:save)
    account if account[:id]
  end

  # An open redirect is a phishing primitive: only a path on this host is ever
  # followed back after a login.
  def safe_return_to(path)
    path.to_s.start_with?("/") && !path.to_s.start_with?("//") ? path : "/"
  end
end

template :layout do
  <<~ERB
    <!doctype html>
    <html>
      <head>
        <meta charset=utf-8>
        <meta name=viewport content="width=device-width,initial-scale=1">
        <title>user-auth</title>
        <%= vite_client_tag %>
        <%= vite_react_refresh_tag %>
        <%= vite_javascript_tag "application.tsx" %>
      </head>
      <body>
        <script data-page="app" type="application/json"><%= JSON.generate(@page).gsub("/", "\\\\/") %></script>
        <div id="app"></div>
      </body>
    </html>
  ERB
end

__END__

export { default } from "@/layouts/app-layout"
