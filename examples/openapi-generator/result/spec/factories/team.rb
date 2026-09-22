# frozen_string_literal: true

# Team -- generated from models.json.
Factory.define(:team, relation: :team) do |f|
  f.sequence(:team) { |n| "team-#{n}" }
  f.can_create_org_repo { false }
  f.description { "" }
  f.includes_all_repositories { false }
  f.name { "" }
  f.organization { "{\"avatar_url\":\"\",\"created\":\"2026-01-01T00:00:00Z\",\"description\":\"\",\"email\":\"\",\"full_name\":\"\",\"id\":0,\"location\":\"\",\"name\":\"\",\"repo_admin_change_team_access\":false,\"username\":\"\",\"visibility\":\"\",\"website\":\"\"}" }
  f.permission { "none" }
  f.units { "[\"\"]" }
  f.units_map { "{}" }
end
