# frozen_string_literal: true
# /orgs/{org}/actions/variables -- scaffolded from the document.

# List variables of an organization
get "/" do
  content_type(:json)
  status(200)
  relations[:action_variable].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/actions/variables", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/actions/variables" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "List variables of an organization" do
      tags "organization"
      operationId "getOrgVariablesList"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "VariableList" do
        schema({
  "type" => "array",
  "items" => Schemas::ActionVariable,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/actions/variables answers 200" do
    Factory[:action_variable]
    assert_api_response :get, 200, path_params: {org: "org"}
  end
end
