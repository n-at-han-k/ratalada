# frozen_string_literal: true

# No page of its own: the reference storefront lives under /:country/:locale,
# and this is the redirect that picks the defaults.
get "/" do
  redirect("/us/en", 302)
end
