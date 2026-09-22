# frozen_string_literal: true

# BranchProtection -- generated from models.json.
Factory.define(:branch_protection, relation: :branch_protection) do |f|
  f.sequence(:name) { |n| "name-#{n}" }
  f.apply_to_admins { false }
  f.approvals_whitelist_teams { "[\"\"]" }
  f.approvals_whitelist_username { "[\"\"]" }
  f.block_on_official_review_requests { false }
  f.block_on_outdated_branch { false }
  f.block_on_rejected_reviews { false }
  f.branch_name { "" }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.dismiss_stale_approvals { false }
  f.enable_approvals_whitelist { false }
  f.enable_merge_whitelist { false }
  f.enable_push { false }
  f.enable_push_whitelist { false }
  f.enable_status_check { false }
  f.ignore_stale_approvals { false }
  f.merge_whitelist_teams { "[\"\"]" }
  f.merge_whitelist_usernames { "[\"\"]" }
  f.protected_file_patterns { "" }
  f.push_whitelist_deploy_keys { false }
  f.push_whitelist_teams { "[\"\"]" }
  f.push_whitelist_usernames { "[\"\"]" }
  f.require_signed_commits { false }
  f.required_approvals { 0 }
  f.rule_name { "" }
  f.status_check_contexts { "[\"\"]" }
  f.unprotected_file_patterns { "" }
  f.updated_at { "2026-01-01T00:00:00Z" }
end
