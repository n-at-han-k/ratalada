# frozen_string_literal: true

# OrganizationPermissions -- columns from models.json, over the table the migrations made.
module Models
  class OrganizationPermissions < ROM::Relation[:sql]
    schema(:organization_permissions, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :can_create_repository, Types::Bool.optional
      attribute :can_read, Types::Bool.optional
      attribute :can_write, Types::Bool.optional
      attribute :is_admin, Types::Bool.optional
      attribute :is_owner, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
