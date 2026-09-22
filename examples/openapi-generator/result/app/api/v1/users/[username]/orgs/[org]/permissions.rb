# frozen_string_literal: true
# /users/{username}/orgs/{org}/permissions -- scaffolded from the document.

# Get user permissions in organization
get "/" do
  content_type(:json)
  record = relations[:organization_permissions].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/users/{username}/orgs/{org}/permissions", type: :openapi do
  openapi_schema :public_api

  api_path "/users/{username}/orgs/{org}/permissions" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "Get user permissions in organization" do
      tags "organization"
      operationId "orgGetUserPermissions"
      response 200, "OrganizationPermissions" do
        schema(Schemas::OrganizationPermissions)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/users/{username}/orgs/{org}/permissions answers 200" do
    Factory[:organization_permission]
    assert_api_response :get, 200, path_params: {username: "username", org: "org"}
  end
end
