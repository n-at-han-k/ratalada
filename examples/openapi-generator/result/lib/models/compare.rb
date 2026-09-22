# frozen_string_literal: true

# Compare -- columns from models.json, over the table the migrations made.
module Models
  class Compare < ROM::Relation[:sql]
    schema(:compare, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :basehead, Types::String.optional
      attribute :commits, Types::Any, read: Parsed
      attribute :files, Types::Any, read: Parsed
      attribute :total_commits, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
