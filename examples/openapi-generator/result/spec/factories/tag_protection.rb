# frozen_string_literal: true

# TagProtection -- generated from models.json.
Factory.define(:tag_protection, relation: :tag_protection) do |f|
  f.sequence(:id) { |n| n }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.name_pattern { "" }
  f.updated_at { "2026-01-01T00:00:00Z" }
  f.whitelist_teams { "[\"\"]" }
  f.whitelist_usernames { "[\"\"]" }
end
