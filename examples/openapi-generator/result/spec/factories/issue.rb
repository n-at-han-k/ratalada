# frozen_string_literal: true

# Issue -- generated from models.json.
Factory.define(:issue, relation: :issue) do |f|
  f.sequence(:index) { |n| "index-#{n}" }
  f.assets { "[{\"browser_download_url\":\"\",\"created_at\":\"2026-01-01T00:00:00Z\",\"download_count\":0,\"id\":0,\"name\":\"\",\"size\":0,\"type\":\"attachment\",\"uuid\":\"\"}]" }
  f.assignee { "{\"active\":false,\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"someone@example.com\",\"followers_count\":0,\"following_count\":0,\"full_name\":\"\",\"html_url\":\"\",\"id\":0,\"is_admin\":false,\"language\":\"\",\"last_login\":\"2026-01-01T00:00:00Z\",\"location\":\"\",\"login\":\"\",\"login_name\":\"\",\"prohibit_login\":false,\"pronouns\":\"\",\"restricted\":false,\"source_id\":0,\"starred_repos_count\":0,\"visibility\":\"\",\"website\":\"\"}" }
  f.assignees { "[{\"active\":false,\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"someone@example.com\",\"followers_count\":0,\"following_count\":0,\"full_name\":\"\",\"html_url\":\"\",\"id\":0,\"is_admin\":false,\"language\":\"\",\"last_login\":\"2026-01-01T00:00:00Z\",\"location\":\"\",\"login\":\"\",\"login_name\":\"\",\"prohibit_login\":false,\"pronouns\":\"\",\"restricted\":false,\"source_id\":0,\"starred_repos_count\":0,\"visibility\":\"\",\"website\":\"\"}]" }
  f.body { "" }
  f.closed_at { "2026-01-01T00:00:00Z" }
  f.comments { 0 }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.due_date { "2026-01-01T00:00:00Z" }
  f.html_url { "" }
  f.is_locked { false }
  f.labels { "[{\"color\":\"\",\"description\":\"\",\"exclusive\":false,\"id\":0,\"is_archived\":false,\"name\":\"\",\"url\":\"\"}]" }
  f.milestone { "{\"closed_at\":\"2026-01-01T00:00:00Z\",\"closed_issues\":0,\"created_at\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"due_on\":\"2026-01-01T00:00:00Z\",\"id\":0,\"open_issues\":0,\"state\":\"\",\"title\":\"\",\"updated_at\":\"2026-01-01T00:00:00Z\"}" }
  f.number { 0 }
  f.original_author { "" }
  f.original_author_id { 0 }
  f.pin_order { 0 }
  f.pull_request { "{\"draft\":false,\"html_url\":\"\",\"merged\":false,\"merged_at\":\"2026-01-01T00:00:00Z\"}" }
  f.ref { "" }
  f.repository { "{\"full_name\":\"\",\"id\":0,\"name\":\"\",\"owner\":\"\"}" }
  f.state { "" }
  f.title { "" }
  f.updated_at { "2026-01-01T00:00:00Z" }
  f.url { "" }
  f.user { "{\"active\":false,\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"someone@example.com\",\"followers_count\":0,\"following_count\":0,\"full_name\":\"\",\"html_url\":\"\",\"id\":0,\"is_admin\":false,\"language\":\"\",\"last_login\":\"2026-01-01T00:00:00Z\",\"location\":\"\",\"login\":\"\",\"login_name\":\"\",\"prohibit_login\":false,\"pronouns\":\"\",\"restricted\":false,\"source_id\":0,\"starred_repos_count\":0,\"visibility\":\"\",\"website\":\"\"}" }
end
