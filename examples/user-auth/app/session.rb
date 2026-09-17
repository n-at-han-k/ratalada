# frozen_string_literal: true

delete "/" do
  sign_out
  # signed_out tells the login page not to let One Tap auto-select the account
  # that was just signed out — without it auto-select fires on arrival and
  # signs them straight back in.
  redirect("/login?signed_out=1", 303)
end
