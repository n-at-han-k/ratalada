# frozen_string_literal: true
# /admin/users/{username}/orgs -- scaffolded from the document.

# Create an organization
post "/" do
  content_type(:json)
  records = relations[:organization]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/users/{username}/orgs", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users/{username}/orgs" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    post "Create an organization" do
      tags "admin"
      operationId "adminCreateOrg"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::CreateOrgOption}},
      )
      response 201, "Organization" do
        schema(Schemas::Organization)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/admin/users/{username}/orgs answers 201" do
    assert_api_response :post, 201, path_params: {username: "username"}, body: {
      "description" => "",
      "email" => "",
      "full_name" => "",
      "location" => "",
      "repo_admin_change_team_access" => false,
      "username" => "",
      "visibility" => "public",
      "website" => "",
    }
  end
end
