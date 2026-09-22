# frozen_string_literal: true

# Hook -- generated from models.json.
Factory.define(:hook, relation: :hook) do |f|
  f.sequence(:id) { |n| n }
  f.active { false }
  f.authorization_header { "" }
  f.branch_filter { "" }
  f.config { "{}" }
  f.content_type { "" }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.events { "[\"\"]" }
  f.metadata { "{}" }
  f.type { "" }
  f.updated_at { "2026-01-01T00:00:00Z" }
  f.url { "" }
end
