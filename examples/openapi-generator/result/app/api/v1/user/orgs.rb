# frozen_string_literal: true
# /user/orgs -- scaffolded from the document.

# List the current user's organizations
get "/" do
  content_type(:json)
  status(200)
  relations[:organization].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/orgs", type: :openapi do
  openapi_schema :public_api

  api_path "/user/orgs" do

    get "List the current user's organizations" do
      tags "organization"
      operationId "orgListCurrentUserOrgs"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "OrganizationListWithoutPagination - Organizations without pagination headers" do
        schema({
  "type" => "array",
  "items" => Schemas::Organization,
})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/user/orgs answers 200" do
    Factory[:organization]
    assert_api_response :get, 200
  end
end
