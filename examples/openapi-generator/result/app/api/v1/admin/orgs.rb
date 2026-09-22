# frozen_string_literal: true
# /admin/orgs -- scaffolded from the document.

# List all organizations
get "/" do
  content_type(:json)
  status(200)
  relations[:organization].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/orgs", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/orgs" do

    get "List all organizations" do
      tags "admin"
      operationId "adminGetAllOrgs"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "OrganizationList" do
        schema({
  "type" => "array",
  "items" => Schemas::Organization,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/admin/orgs answers 200" do
    Factory[:organization]
    assert_api_response :get, 200
  end
end
