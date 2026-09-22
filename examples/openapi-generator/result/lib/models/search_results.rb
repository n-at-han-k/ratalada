# frozen_string_literal: true

# SearchResults -- columns from models.json, over the table the migrations made.
module Models
  class SearchResults < ROM::Relation[:sql]
    schema(:search_results, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :data, Types::Any, read: Parsed
      attribute :ok, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
