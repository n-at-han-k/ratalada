# frozen_string_literal: true
# /orgs -- scaffolded from the document.

# Create an organization
post "/" do
  content_type(:json)
  records = relations[:organization]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List all organizations
get "/" do
  content_type(:json)
  status(200)
  relations[:organization].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs" do

    get "List all organizations" do
      tags "organization"
      operationId "orgGetAll"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "OrganizationList" do
        schema({
  "type" => "array",
  "items" => Schemas::Organization,
})
      end
    end

    post "Create an organization" do
      tags "organization"
      operationId "orgCreate"
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

  it "GET /api/v1/orgs answers 200" do
    Factory[:organization]
    assert_api_response :get, 200
  end

  it "POST /api/v1/orgs answers 201" do
    assert_api_response :post, 201, body: {
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
