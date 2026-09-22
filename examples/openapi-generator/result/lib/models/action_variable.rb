# frozen_string_literal: true

# ActionVariable -- columns from models.json, over the table the migrations made.
module Models
  class ActionVariable < ROM::Relation[:sql]
    schema(:action_variable, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :variablename, Types::String.optional
      attribute :data, Types::String.optional
      attribute :name, Types::String.optional
      attribute :owner_id, Types::Integer.optional
      attribute :repo_id, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
