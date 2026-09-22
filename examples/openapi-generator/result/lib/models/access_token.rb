# frozen_string_literal: true

# AccessToken -- columns from models.json, over the table the migrations made.
module Models
  class AccessToken < ROM::Relation[:sql]
    schema(:access_token, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :name, Types::String.optional
      attribute :repositories, Types::Any, read: Parsed
      attribute :scopes, Types::Any, read: Parsed
      attribute :sha1, Types::String.optional
      attribute :token_last_eight, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
