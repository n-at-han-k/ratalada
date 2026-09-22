# frozen_string_literal: true

# Milestone -- generated from models.json.
Factory.define(:milestone, relation: :milestone) do |f|
  f.sequence(:id) { |n| n }
  f.closed_at { "2026-01-01T00:00:00Z" }
  f.closed_issues { 0 }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.description { "" }
  f.due_on { "2026-01-01T00:00:00Z" }
  f.open_issues { 0 }
  f.state { "" }
  f.title { "" }
  f.updated_at { "2026-01-01T00:00:00Z" }
end
