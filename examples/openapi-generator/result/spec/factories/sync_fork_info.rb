# frozen_string_literal: true

# SyncForkInfo -- generated from models.json.
Factory.define(:sync_fork_info, relation: :sync_fork_info) do |f|
  f.sequence(:branch) { |n| "branch-#{n}" }
  f.allowed { false }
  f.base_commit { "" }
  f.commits_behind { 0 }
  f.fork_commit { "" }
end
