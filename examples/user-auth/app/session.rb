# frozen_string_literal: true

delete "/" do
  sign_out
  redirect("/login", 303)
end
