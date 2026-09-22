# frozen_string_literal: true

# ActionRunner -- columns from models.json, over the table the migrations made.
module Models
  class ActionRunner < ROM::Relation[:sql]
    schema(:action_runner, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :runner_id, Types::String.optional
      attribute :description, Types::String.optional
      attribute :ephemeral, Types::Bool.optional
      attribute :labels, Types::Any, read: Parsed
      attribute :name, Types::String.optional
      attribute :owner_id, Types::Integer.optional
      attribute :repo_id, Types::Integer.optional
      attribute :status, Types::String.optional
      attribute :uuid, Types::String.optional
      attribute :version, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
