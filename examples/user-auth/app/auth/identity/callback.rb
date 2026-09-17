# frozen_string_literal: true

# Where the credentials form posts, and where omniauth-identity sends a fresh
# registration too. By the time this runs the strategy has located the account
# and checked the password — a failure never reaches here, it is redirected to
# /auth/failure.
post "/" do
  sign_in(env.fetch("omniauth.auth")["uid"])
  redirect(safe_return_to(params["return_to"]), 303)
end
