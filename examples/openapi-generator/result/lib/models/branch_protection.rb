# frozen_string_literal: true

# BranchProtection -- columns from models.json, over the table the migrations made.
module Models
  class BranchProtection < ROM::Relation[:sql]
    schema(:branch_protection, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :name, Types::String.optional
      attribute :apply_to_admins, Types::Bool.optional
      attribute :approvals_whitelist_teams, Types::Any, read: Parsed
      attribute :approvals_whitelist_username, Types::Any, read: Parsed
      attribute :block_on_official_review_requests, Types::Bool.optional
      attribute :block_on_outdated_branch, Types::Bool.optional
      attribute :block_on_rejected_reviews, Types::Bool.optional
      attribute :branch_name, Types::String.optional
      attribute :created_at, Types::String.optional
      attribute :dismiss_stale_approvals, Types::Bool.optional
      attribute :enable_approvals_whitelist, Types::Bool.optional
      attribute :enable_merge_whitelist, Types::Bool.optional
      attribute :enable_push, Types::Bool.optional
      attribute :enable_push_whitelist, Types::Bool.optional
      attribute :enable_status_check, Types::Bool.optional
      attribute :ignore_stale_approvals, Types::Bool.optional
      attribute :merge_whitelist_teams, Types::Any, read: Parsed
      attribute :merge_whitelist_usernames, Types::Any, read: Parsed
      attribute :protected_file_patterns, Types::String.optional
      attribute :push_whitelist_deploy_keys, Types::Bool.optional
      attribute :push_whitelist_teams, Types::Any, read: Parsed
      attribute :push_whitelist_usernames, Types::Any, read: Parsed
      attribute :require_signed_commits, Types::Bool.optional
      attribute :required_approvals, Types::Integer.optional
      attribute :rule_name, Types::String.optional
      attribute :status_check_contexts, Types::Any, read: Parsed
      attribute :unprotected_file_patterns, Types::String.optional
      attribute :updated_at, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
