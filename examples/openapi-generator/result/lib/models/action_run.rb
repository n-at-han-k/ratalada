# frozen_string_literal: true

# ActionRun -- columns from models.json, over the table the migrations made.
module Models
  class ActionRun < ROM::Relation[:sql]
    schema(:action_run, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :run_id, Types::String.optional
      attribute :ScheduleID, Types::Integer.optional
      attribute :approved_by, Types::Integer.optional
      attribute :commit_sha, Types::String.optional
      attribute :created, Types::String.optional
      attribute :duration, Types::Integer.optional
      attribute :event, Types::String.optional
      attribute :event_payload, Types::String.optional
      attribute :html_url, Types::String.optional
      attribute :index_in_repo, Types::Integer.optional
      attribute :is_fork_pull_request, Types::Bool.optional
      attribute :is_ref_deleted, Types::Bool.optional
      attribute :need_approval, Types::Bool.optional
      attribute :prettyref, Types::String.optional
      attribute :repository, Types::Any, read: Parsed
      attribute :started, Types::String.optional
      attribute :status, Types::String.optional
      attribute :stopped, Types::String.optional
      attribute :title, Types::String.optional
      attribute :trigger_event, Types::String.optional
      attribute :trigger_user, Types::Any, read: Parsed
      attribute :updated, Types::String.optional
      attribute :workflow_id, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
