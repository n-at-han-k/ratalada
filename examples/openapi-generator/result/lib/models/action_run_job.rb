# frozen_string_literal: true

# ActionRunJob -- columns from models.json, over the table the migrations made.
module Models
  class ActionRunJob < ROM::Relation[:sql]
    schema(:action_run_job, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :job_id, Types::String.optional
      attribute :attempt, Types::Integer.optional
      attribute :handle, Types::String.optional
      attribute :html_url, Types::String.optional
      attribute :name, Types::String.optional
      attribute :needs, Types::Any, read: Parsed
      attribute :owner_id, Types::Integer.optional
      attribute :repo_id, Types::Integer.optional
      attribute :run_id, Types::Integer.optional
      attribute :runs_on, Types::Any, read: Parsed
      attribute :status, Types::String.optional
      attribute :steps, Types::Any, read: Parsed
      attribute :task_id, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
