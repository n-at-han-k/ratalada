# frozen_string_literal: true

# ServerVersion -- columns from models.json, over the table the migrations made.
module Models
  class ServerVersion < ROM::Relation[:sql]
    schema(:server_version, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :version, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
