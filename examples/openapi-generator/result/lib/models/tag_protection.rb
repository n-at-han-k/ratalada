# frozen_string_literal: true

# TagProtection -- columns from models.json, over the table the migrations made.
module Models
  class TagProtection < ROM::Relation[:sql]
    schema(:tag_protection, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :name_pattern, Types::String.optional
      attribute :updated_at, Types::String.optional
      attribute :whitelist_teams, Types::Any, read: Parsed
      attribute :whitelist_usernames, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
