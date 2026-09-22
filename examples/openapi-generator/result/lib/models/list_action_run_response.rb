# frozen_string_literal: true

# ListActionRunResponse -- columns from models.json, over the table the migrations made.
module Models
  class ListActionRunResponse < ROM::Relation[:sql]
    schema(:list_action_run_response, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :total_count, Types::Integer.optional
      attribute :workflow_runs, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
