# frozen_string_literal: true

# CombinedStatus -- columns from models.json, over the table the migrations made.
module Models
  class CombinedStatus < ROM::Relation[:sql]
    schema(:combined_status, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :commit_url, Types::String.optional
      attribute :repository, Types::Any, read: Parsed
      attribute :sha, Types::String.optional
      attribute :state, Types::String.optional
      attribute :statuses, Types::Any, read: Parsed
      attribute :total_count, Types::Integer.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
