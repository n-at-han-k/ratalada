# frozen_string_literal: true

# OAuth2Application -- generated from models.json.
Factory.define(:o_auth2_application, relation: :o_auth2_application) do |f|
  f.client_id { "" }
  f.client_secret { "" }
  f.confidential_client { false }
  f.created { "2026-01-01T00:00:00Z" }
  f.name { "" }
  f.redirect_uris { "[\"\"]" }
end
