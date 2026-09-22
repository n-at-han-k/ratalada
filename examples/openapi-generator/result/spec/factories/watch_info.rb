# frozen_string_literal: true

# WatchInfo -- generated from models.json.
Factory.define(:watch_info, relation: :watch_info) do |f|
  f.created_at { "2026-01-01T00:00:00Z" }
  f.ignored { false }
  f.reason { "{}" }
  f.repository_url { "" }
  f.subscribed { false }
  f.url { "" }
end
