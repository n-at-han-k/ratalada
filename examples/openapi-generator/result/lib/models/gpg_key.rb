# frozen_string_literal: true

# GPGKey -- columns from models.json, over the table the migrations made.
module Models
  class GPGKey < ROM::Relation[:sql]
    schema(:gpg_key, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :can_certify, Types::Bool.optional
      attribute :can_encrypt_comms, Types::Bool.optional
      attribute :can_encrypt_storage, Types::Bool.optional
      attribute :can_sign, Types::Bool.optional
      attribute :created_at, Types::String.optional
      attribute :emails, Types::Any, read: Parsed
      attribute :expires_at, Types::String.optional
      attribute :key_id, Types::String.optional
      attribute :primary_key_id, Types::String.optional
      attribute :public_key, Types::String.optional
      attribute :subkeys, Types::Any, read: Parsed
      attribute :verified, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
