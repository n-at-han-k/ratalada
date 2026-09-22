# frozen_string_literal: true

# NodeInfo -- columns from models.json, over the table the migrations made.
module Models
  class NodeInfo < ROM::Relation[:sql]
    schema(:node_info, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :metadata, Types::Any, read: Parsed
      attribute :openRegistrations, Types::Bool.optional
      attribute :protocols, Types::Any, read: Parsed
      attribute :services, Types::Any, read: Parsed
      attribute :software, Types::Any, read: Parsed
      attribute :usage, Types::Any, read: Parsed
      attribute :version, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
