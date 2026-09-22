# frozen_string_literal: true

# OrganizationPermissions -- generated from models.json.
Factory.define(:organization_permission, relation: :organization_permissions) do |f|
  f.can_create_repository { false }
  f.can_read { false }
  f.can_write { false }
  f.is_admin { false }
  f.is_owner { false }
end
