# frozen_string_literal: true

# DeployKey -- columns from models.json, over the table the migrations made.
module Models
  class DeployKey < ROM::Relation[:sql]
    schema(:deploy_key, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :fingerprint, Types::String.optional
      attribute :key, Types::String.optional
      attribute :key_id, Types::Integer.optional
      attribute :read_only, Types::Bool.optional
      attribute :repository, Types::Any, read: Parsed
      attribute :title, Types::String.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
