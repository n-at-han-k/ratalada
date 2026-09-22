# frozen_string_literal: true

# AccessToken -- generated from models.json.
Factory.define(:access_token, relation: :access_token) do |f|
  f.created_at { "2026-01-01T00:00:00Z" }
  f.name { "" }
  f.repositories { "[{\"full_name\":\"\",\"id\":0,\"name\":\"\",\"owner\":\"\"}]" }
  f.scopes { "[\"\"]" }
  f.sha1 { "" }
  f.token_last_eight { "" }
end
