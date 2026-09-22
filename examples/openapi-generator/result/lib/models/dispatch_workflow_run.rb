# frozen_string_literal: true

# DispatchWorkflowRun -- columns from models.json, over the table the migrations made.
module Models
  class DispatchWorkflowRun < ROM::Relation[:sql]
    schema(:dispatch_workflow_run, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :jobs, Types::Any, read: Parsed
      attribute :run_number, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
