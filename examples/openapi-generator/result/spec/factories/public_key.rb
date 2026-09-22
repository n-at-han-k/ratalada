# frozen_string_literal: true

# PublicKey -- generated from models.json.
Factory.define(:public_key, relation: :public_key) do |f|
  f.sequence(:id) { |n| n }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.fingerprint { "" }
  f.key { "" }
  f.key_type { "" }
  f.read_only { false }
  f.title { "" }
  f.updated_at { "2026-01-01T00:00:00Z" }
  f.url { "" }
  f.user { "{\"active\":false,\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"someone@example.com\",\"followers_count\":0,\"following_count\":0,\"full_name\":\"\",\"html_url\":\"\",\"id\":0,\"is_admin\":false,\"language\":\"\",\"last_login\":\"2026-01-01T00:00:00Z\",\"location\":\"\",\"login\":\"\",\"login_name\":\"\",\"prohibit_login\":false,\"pronouns\":\"\",\"restricted\":false,\"source_id\":0,\"starred_repos_count\":0,\"visibility\":\"\",\"website\":\"\"}" }
  f.verified { false }
end
