# frozen_string_literal: true

# Attachment -- generated from models.json.
Factory.define(:attachment, relation: :attachment) do |f|
  f.sequence(:attachment_id) { |n| "attachment_id-#{n}" }
  f.browser_download_url { "" }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.download_count { 0 }
  f.name { "" }
  f.size { 0 }
  f.type { "attachment" }
  f.uuid { "" }
end
