# frozen_string_literal: true

# GitBlob -- columns from models.json, over the table the migrations made.
module Models
  class GitBlob < ROM::Relation[:sql]
    schema(:git_blob, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :content, Types::String.optional
      attribute :encoding, Types::String.optional
      attribute :sha, Types::String.optional
      attribute :size, Types::Integer.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
