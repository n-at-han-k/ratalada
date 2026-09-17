# frozen_string_literal: true

# Google One Tap: the same destination as the redirect callback by a different
# road. Rather than bouncing the browser through Google, the GSI script in the
# login page obtains an ID token in the browser and posts it here.
#
# Which means the token is UNVERIFIED user input, unlike the callback's, where
# OmniAuth fetched it over a back channel. GoogleIDToken checks the signature,
# audience, issuer and expiry; a token that fails any of those is
# indistinguishable here from one that was never issued.
post "/" do
  claims = GoogleIDToken.claims(params["credential"])
  email  = claims && claims["email"].to_s.downcase

  if claims.nil? || !claims["email_verified"] || email.to_s.empty?
    page_errors(auth_key: "Google has not verified that address")
    redirect("/login", 303)
  else
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
