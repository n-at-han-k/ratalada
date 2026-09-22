# frozen_string_literal: true

# Note -- columns from models.json, over the table the migrations made.
module Models
  class Note < ROM::Relation[:sql]
    schema(:note, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :sha, Types::String.optional
      attribute :commit, Types::Any, read: Parsed
      attribute :message, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
