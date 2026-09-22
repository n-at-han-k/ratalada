# frozen_string_literal: true

# GitTreeResponse -- columns from models.json, over the table the migrations made.
module Models
  class GitTreeResponse < ROM::Relation[:sql]
    schema(:git_tree_response, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :page, Types::Integer.optional
      attribute :sha, Types::String.optional
      attribute :total_count, Types::Integer.optional
      attribute :tree, Types::Any, read: Parsed
      attribute :truncated, Types::Bool.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
