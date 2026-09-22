# frozen_string_literal: true

# Email -- generated from models.json.
Factory.define(:email, relation: :email) do |f|
  f.email { "someone@example.com" }
  f.primary { false }
  f.user_id { 0 }
  f.username { "" }
  f.verified { false }
end
