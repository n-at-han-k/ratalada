# frozen_string_literal: true

# ActionArtifact -- generated from models.json.
Factory.define(:action_artifact, relation: :action_artifact) do |f|
  f.sequence(:artifact_id) { |n| "artifact_id-#{n}" }
  f.archive_download_url { "" }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.expired { false }
  f.expires_at { "2026-01-01T00:00:00Z" }
  f.name { "" }
  f.run_id { 0 }
  f.size_in_bytes { 0 }
  f.updated_at { "2026-01-01T00:00:00Z" }
end
