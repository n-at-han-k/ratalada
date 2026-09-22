# frozen_string_literal: true

# Secret -- columns from models.json, over the table the migrations made.
module Models
  class Secret < ROM::Relation[:sql]
    schema(:secret, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :name, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
