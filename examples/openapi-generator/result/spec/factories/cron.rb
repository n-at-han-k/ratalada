# frozen_string_literal: true

# Cron -- generated from models.json.
Factory.define(:cron, relation: :cron) do |f|
  f.exec_times { 0 }
  f.name { "" }
  f.next { "2026-01-01T00:00:00Z" }
  f.prev { "2026-01-01T00:00:00Z" }
  f.schedule { "" }
end
