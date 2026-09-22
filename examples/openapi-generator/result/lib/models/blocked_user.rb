# frozen_string_literal: true

# BlockedUser -- columns from models.json, over the table the migrations made.
module Models
  class BlockedUser < ROM::Relation[:sql]
    schema(:blocked_user, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :block_id, Types::Integer.optional
      attribute :created_at, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
