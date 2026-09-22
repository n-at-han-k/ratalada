# frozen_string_literal: true

# Reaction -- columns from models.json, over the table the migrations made.
module Models
  class Reaction < ROM::Relation[:sql]
    schema(:reaction, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :content, Types::String.optional
      attribute :created_at, Types::String.optional
      attribute :user, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
