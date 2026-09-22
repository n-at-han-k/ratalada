# frozen_string_literal: true

# Package -- columns from models.json, over the table the migrations made.
module Models
  class Package < ROM::Relation[:sql]
    schema(:package, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :creator, Types::Any, read: Parsed
      attribute :html_url, Types::String.optional
      attribute :name, Types::String.optional
      attribute :owner, Types::Any, read: Parsed
      attribute :repository, Types::Any, read: Parsed
      attribute :type, Types::String.optional
      attribute :version, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
