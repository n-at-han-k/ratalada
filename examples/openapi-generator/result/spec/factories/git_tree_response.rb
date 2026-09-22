# frozen_string_literal: true

# GitTreeResponse -- generated from models.json.
Factory.define(:git_tree_response, relation: :git_tree_response) do |f|
  f.sequence(:sha) { |n| "sha-#{n}" }
  f.page { 0 }
  f.total_count { 0 }
  f.tree { "[{\"mode\":\"\",\"path\":\"\",\"sha\":\"\",\"size\":0,\"type\":\"\",\"url\":\"\"}]" }
  f.truncated { false }
  f.url { "" }
end
