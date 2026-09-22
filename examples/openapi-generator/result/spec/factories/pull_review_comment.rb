# frozen_string_literal: true

# PullReviewComment -- generated from models.json.
Factory.define(:pull_review_comment, relation: :pull_review_comment) do |f|
  f.sequence(:comment) { |n| "comment-#{n}" }
  f.body { "" }
  f.commit_id { "" }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.diff_hunk { "" }
  f.extra_lines_count { 0 }
  f.html_url { "" }
  f.original_commit_id { "" }
  f.original_position { 0 }
  f.path { "" }
  f.position { 0 }
  f.pull_request_review_id { 0 }
  f.pull_request_url { "" }
  f.resolver { "{\"active\":false,\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"someone@example.com\",\"followers_count\":0,\"following_count\":0,\"full_name\":\"\",\"html_url\":\"\",\"id\":0,\"is_admin\":false,\"language\":\"\",\"last_login\":\"2026-01-01T00:00:00Z\",\"location\":\"\",\"login\":\"\",\"login_name\":\"\",\"prohibit_login\":false,\"pronouns\":\"\",\"restricted\":false,\"source_id\":0,\"starred_repos_count\":0,\"visibility\":\"\",\"website\":\"\"}" }
  f.updated_at { "2026-01-01T00:00:00Z" }
  f.user { "{\"active\":false,\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"someone@example.com\",\"followers_count\":0,\"following_count\":0,\"full_name\":\"\",\"html_url\":\"\",\"id\":0,\"is_admin\":false,\"language\":\"\",\"last_login\":\"2026-01-01T00:00:00Z\",\"location\":\"\",\"login\":\"\",\"login_name\":\"\",\"prohibit_login\":false,\"pronouns\":\"\",\"restricted\":false,\"source_id\":0,\"starred_repos_count\":0,\"visibility\":\"\",\"website\":\"\"}" }
end
