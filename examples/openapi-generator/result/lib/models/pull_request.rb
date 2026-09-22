# frozen_string_literal: true

# PullRequest -- columns from models.json, over the table the migrations made.
module Models
  class PullRequest < ROM::Relation[:sql]
    schema(:pull_request, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :index, Types::String.optional
      attribute :additions, Types::Integer.optional
      attribute :allow_maintainer_edit, Types::Bool.optional
      attribute :assignee, Types::Any, read: Parsed
      attribute :assignees, Types::Any, read: Parsed
      attribute :base, Types::Any, read: Parsed
      attribute :body, Types::String.optional
      attribute :changed_files, Types::Integer.optional
      attribute :closed_at, Types::String.optional
      attribute :comments, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :deletions, Types::Integer.optional
      attribute :diff_url, Types::String.optional
      attribute :draft, Types::Bool.optional
      attribute :due_date, Types::String.optional
      attribute :flow, Types::Integer.optional
      attribute :head, Types::Any, read: Parsed
      attribute :html_url, Types::String.optional
      attribute :is_locked, Types::Bool.optional
      attribute :labels, Types::Any, read: Parsed
      attribute :merge_base, Types::String.optional
      attribute :merge_commit_sha, Types::String.optional
      attribute :mergeable, Types::Bool.optional
      attribute :merged, Types::Bool.optional
      attribute :merged_at, Types::String.optional
      attribute :merged_by, Types::Any, read: Parsed
      attribute :milestone, Types::Any, read: Parsed
      attribute :number, Types::Integer.optional
      attribute :patch_url, Types::String.optional
      attribute :pin_order, Types::Integer.optional
      attribute :requested_reviewers, Types::Any, read: Parsed
      attribute :requested_reviewers_teams, Types::Any, read: Parsed
      attribute :review_comments, Types::Integer.optional
      attribute :state, Types::String.optional
      attribute :title, Types::String.optional
      attribute :updated_at, Types::String.optional
      attribute :url, Types::String.optional
      attribute :user, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
