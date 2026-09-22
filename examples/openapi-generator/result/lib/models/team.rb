# frozen_string_literal: true

# Team -- columns from models.json, over the table the migrations made.
module Models
  class Team < ROM::Relation[:sql]
    schema(:team, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :team, Types::String.optional
      attribute :can_create_org_repo, Types::Bool.optional
      attribute :description, Types::String.optional
      attribute :includes_all_repositories, Types::Bool.optional
      attribute :name, Types::String.optional
      attribute :organization, Types::Any, read: Parsed
      attribute :permission, Types::String.optional
      attribute :units, Types::Any, read: Parsed
      attribute :units_map, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
