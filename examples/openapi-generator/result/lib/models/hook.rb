# frozen_string_literal: true

# Hook -- columns from models.json, over the table the migrations made.
module Models
  class Hook < ROM::Relation[:sql]
    schema(:hook, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :active, Types::Bool.optional
      attribute :authorization_header, Types::String.optional
      attribute :branch_filter, Types::String.optional
      attribute :config, Types::Any, read: Parsed
      attribute :content_type, Types::String.optional
      attribute :created_at, Types::String.optional
      attribute :events, Types::Any, read: Parsed
      attribute :metadata, Types::Any, read: Parsed
      attribute :type, Types::String.optional
      attribute :updated_at, Types::String.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
