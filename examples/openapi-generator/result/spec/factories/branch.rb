# frozen_string_literal: true

# Branch -- generated from models.json.
Factory.define(:branch, relation: :branch) do |f|
  f.sequence(:branch) { |n| "branch-#{n}" }
  f.commit { "{\"added\":[\"\"],\"author\":{\"email\":\"someone@example.com\",\"name\":\"\",\"username\":\"\"},\"committer\":{\"email\":\"someone@example.com\",\"name\":\"\",\"username\":\"\"},\"id\":\"\",\"message\":\"\",\"modified\":[\"\"],\"removed\":[\"\"],\"timestamp\":\"2026-01-01T00:00:00Z\",\"url\":\"\",\"verification\":{\"payload\":\"\",\"reason\":\"\",\"signature\":\"\",\"signer\":{\"email\":\"someone@example.com\",\"name\":\"\",\"username\":\"\"},\"verified\":false}}" }
  f.effective_branch_protection_name { "" }
  f.enable_status_check { false }
  f.name { "" }
  f.protected { false }
  f.required_approvals { 0 }
  f.status_check_contexts { "[\"\"]" }
  f.user_can_merge { false }
  f.user_can_push { false }
end
