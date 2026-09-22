# frozen_string_literal: true

# Organization -- columns from models.json, over the table the migrations made.
module Models
  class Organization < ROM::Relation[:sql]
    schema(:organization, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :org, Types::String.optional
      attribute :avatar_url, Types::String.optional
      attribute :created, Types::String.optional
      attribute :description, Types::String.optional
      attribute :email, Types::String.optional
      attribute :full_name, Types::String.optional
      attribute :location, Types::String.optional
      attribute :name, Types::String.optional
      attribute :repo_admin_change_team_access, Types::Bool.optional
      attribute :username, Types::String.optional
      attribute :visibility, Types::String.optional
      attribute :website, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
