# frozen_string_literal: true

# Reference -- columns from models.json, over the table the migrations made.
module Models
  class Reference < ROM::Relation[:sql]
    schema(:reference, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :object, Types::Any, read: Parsed
      attribute :ref, Types::String.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
