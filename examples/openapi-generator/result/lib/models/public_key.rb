# frozen_string_literal: true

# PublicKey -- columns from models.json, over the table the migrations made.
module Models
  class PublicKey < ROM::Relation[:sql]
    schema(:public_key, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :fingerprint, Types::String.optional
      attribute :key, Types::String.optional
      attribute :key_type, Types::String.optional
      attribute :read_only, Types::Bool.optional
      attribute :title, Types::String.optional
      attribute :updated_at, Types::String.optional
      attribute :url, Types::String.optional
      attribute :user, Types::Any, read: Parsed
      attribute :verified, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
