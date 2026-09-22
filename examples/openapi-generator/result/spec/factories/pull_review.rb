# frozen_string_literal: true

# PullReview -- generated from models.json.
Factory.define(:pull_review, relation: :pull_review) do |f|
  f.sequence(:id) { |n| n }
  f.body { "" }
  f.comments_count { 0 }
  f.commit_id { "" }
  f.dismissed { false }
  f.html_url { "" }
  f.official { false }
  f.pull_request_url { "" }
  f.stale { false }
  f.state { "" }
  f.submitted_at { "2026-01-01T00:00:00Z" }
  f.team { "{\"can_create_org_repo\":false,\"description\":\"\",\"id\":0,\"includes_all_repositories\":false,\"name\":\"\",\"organization\":{\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"\",\"full_name\":\"\",\"id\":0,\"location\":\"\",\"name\":\"\",\"repo_admin_change_team_access\":false,\"username\":\"\",\"visibility\":\"\",\"website\":\"\"},\"permission\":\"none\",\"units\":[\"\"],\"units_map\":{}}" }
  f.updated_at { "2026-01-01T00:00:00Z" }
  f.user { "{\"active\":false,\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"someone@example.com\",\"followers_count\":0,\"following_count\":0,\"full_name\":\"\",\"html_url\":\"\",\"id\":0,\"is_admin\":false,\"language\":\"\",\"last_login\":\"2026-01-01T00:00:00Z\",\"location\":\"\",\"login\":\"\",\"login_name\":\"\",\"prohibit_login\":false,\"pronouns\":\"\",\"restricted\":false,\"source_id\":0,\"starred_repos_count\":0,\"visibility\":\"\",\"website\":\"\"}" }
end
