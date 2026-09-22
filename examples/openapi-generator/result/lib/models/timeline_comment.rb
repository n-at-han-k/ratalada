# frozen_string_literal: true

# TimelineComment -- columns from models.json, over the table the migrations made.
module Models
  class TimelineComment < ROM::Relation[:sql]
    schema(:timeline_comment, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :assignee, Types::Any, read: Parsed
      attribute :assignee_team, Types::Any, read: Parsed
      attribute :body, Types::String.optional
      attribute :created_at, Types::String.optional
      attribute :dependent_issue, Types::Any, read: Parsed
      attribute :html_url, Types::String.optional
      attribute :issue_url, Types::String.optional
      attribute :label, Types::Any, read: Parsed
      attribute :milestone, Types::Any, read: Parsed
      attribute :new_ref, Types::String.optional
      attribute :new_title, Types::String.optional
      attribute :old_milestone, Types::Any, read: Parsed
      attribute :old_project_id, Types::Integer.optional
      attribute :old_ref, Types::String.optional
      attribute :old_title, Types::String.optional
      attribute :project_id, Types::Integer.optional
      attribute :pull_request_url, Types::String.optional
      attribute :ref_action, Types::String.optional
      attribute :ref_comment, Types::Any, read: Parsed
      attribute :ref_commit_sha, Types::String.optional
      attribute :ref_issue, Types::Any, read: Parsed
      attribute :removed_assignee, Types::Bool.optional
      attribute :resolve_doer, Types::Any, read: Parsed
      attribute :review_id, Types::Integer.optional
      attribute :tracked_time, Types::Any, read: Parsed
      attribute :type, Types::String.optional
      attribute :updated_at, Types::String.optional
      attribute :user, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
