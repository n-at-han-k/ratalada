# frozen_string_literal: true

# Reaction -- generated from models.json.
Factory.define(:reaction, relation: :reaction) do |f|
  f.content { "" }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.user { "{\"active\":false,\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"someone@example.com\",\"followers_count\":0,\"following_count\":0,\"full_name\":\"\",\"html_url\":\"\",\"id\":0,\"is_admin\":false,\"language\":\"\",\"last_login\":\"2026-01-01T00:00:00Z\",\"location\":\"\",\"login\":\"\",\"login_name\":\"\",\"prohibit_login\":false,\"pronouns\":\"\",\"restricted\":false,\"source_id\":0,\"starred_repos_count\":0,\"visibility\":\"\",\"website\":\"\"}" }
end
