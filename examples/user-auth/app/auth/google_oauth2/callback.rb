# frozen_string_literal: true

# Google comes back by GET redirect, and its `uid` is a Google subject id
# rather than an Account id, so this is a separate route rather than a branch
# in the identity callback.
#
# The account is keyed on EMAIL, which is only safe because of the
# email_verified check: without it, anyone who can set an unverified address on
# a Google account could claim someone else's login here.
get "/" do
  auth     = env.fetch("omniauth.auth")
  info     = auth["info"] || {}
  email    = info["email"].to_s.downcase
  verified = info["email_verified"] || auth.dig("extra", "raw_info", "email_verified")

  if email.empty? || !verified
    page_errors(auth_key: "Google has not verified that address")
    redirect("/login", 303)
  else
    # A verified Google sign-in is proof of the address in its own right, so a
    # first-time Google user gets an account here.
    account = google_account(email)

    if account
      sign_in(account[:id])
      redirect(safe_return_to(params["return_to"]), 303)
    else
      page_errors(auth_key: "Could not create an account for #{email}")
      redirect("/login", 303)
    end
  end
end
