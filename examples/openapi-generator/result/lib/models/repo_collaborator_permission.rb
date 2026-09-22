# frozen_string_literal: true

# RepoCollaboratorPermission -- columns from models.json, over the table the migrations made.
module Models
  class RepoCollaboratorPermission < ROM::Relation[:sql]
    schema(:repo_collaborator_permission, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :permission, Types::String.optional
      attribute :role_name, Types::String.optional
      attribute :user, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
