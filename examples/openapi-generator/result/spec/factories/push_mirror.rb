# frozen_string_literal: true

# PushMirror -- generated from models.json.
Factory.define(:push_mirror, relation: :push_mirror) do |f|
  f.sequence(:name) { |n| "name-#{n}" }
  f.branch_filter { "" }
  f.created { "2026-01-01T00:00:00Z" }
  f.interval { "" }
  f.last_error { "" }
  f.last_update { "2026-01-01T00:00:00Z" }
  f.public_key { "" }
  f.remote_address { "" }
  f.remote_name { "" }
  f.repo_name { "" }
  f.sync_on_commit { false }
end
