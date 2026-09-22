# frozen_string_literal: true

# Organization -- generated from models.json.
Factory.define(:organization, relation: :organization) do |f|
  f.sequence(:org) { |n| "org-#{n}" }
  f.avatar_url { "" }
  f.created { "2026-01-01T00:00:00Z" }
  f.description { "" }
  f.email { "" }
  f.full_name { "" }
  f.location { "" }
  f.name { "" }
  f.repo_admin_change_team_access { false }
  f.username { "" }
  f.visibility { "" }
  f.website { "" }
end
