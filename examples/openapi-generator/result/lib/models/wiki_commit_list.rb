# frozen_string_literal: true

# WikiCommitList -- columns from models.json, over the table the migrations made.
module Models
  class WikiCommitList < ROM::Relation[:sql]
    schema(:wiki_commit_list, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :pageName, Types::String.optional
      attribute :commits, Types::Any, read: Parsed
      attribute :count, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
