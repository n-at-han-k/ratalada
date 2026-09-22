# frozen_string_literal: true

# CommitStatus -- columns from models.json, over the table the migrations made.
module Models
  class CommitStatus < ROM::Relation[:sql]
    schema(:commit_status, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :sha, Types::String.optional
      attribute :context, Types::String.optional
      attribute :created_at, Types::String.optional
      attribute :creator, Types::Any, read: Parsed
      attribute :description, Types::String.optional
      attribute :status, Types::String.optional
      attribute :target_url, Types::String.optional
      attribute :updated_at, Types::String.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
