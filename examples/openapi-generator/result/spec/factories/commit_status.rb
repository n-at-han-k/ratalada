# frozen_string_literal: true

# CommitStatus -- generated from models.json.
Factory.define(:commit_status, relation: :commit_status) do |f|
  f.sequence(:sha) { |n| "sha-#{n}" }
  f.context { "" }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.creator { "{\"active\":false,\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"someone@example.com\",\"followers_count\":0,\"following_count\":0,\"full_name\":\"\",\"html_url\":\"\",\"id\":0,\"is_admin\":false,\"language\":\"\",\"last_login\":\"2026-01-01T00:00:00Z\",\"location\":\"\",\"login\":\"\",\"login_name\":\"\",\"prohibit_login\":false,\"pronouns\":\"\",\"restricted\":false,\"source_id\":0,\"starred_repos_count\":0,\"visibility\":\"\",\"website\":\"\"}" }
  f.description { "" }
  f.status { "" }
  f.target_url { "" }
  f.updated_at { "2026-01-01T00:00:00Z" }
  f.url { "" }
end
