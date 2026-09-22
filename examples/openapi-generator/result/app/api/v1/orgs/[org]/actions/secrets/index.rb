# frozen_string_literal: true
# /orgs/{org}/actions/secrets -- scaffolded from the document.

# List actions secrets of an organization
get "/" do
  content_type(:json)
  status(200)
  relations[:secret].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/actions/secrets", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/actions/secrets" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "List actions secrets of an organization" do
      tags "organization"
      operationId "orgListActionsSecrets"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "SecretList" do
        schema({
  "type" => "array",
  "items" => Schemas::Secret,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/actions/secrets answers 200" do
    Factory[:secret]
    assert_api_response :get, 200, path_params: {org: "org"}
  end
end
