# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/secrets -- scaffolded from the document.

# List an repo's actions secrets
get "/" do
  content_type(:json)
  status(200)
  relations[:secret].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/secrets", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/secrets" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List an repo's actions secrets" do
      tags "repository"
      operationId "repoListActionsSecrets"
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

  it "GET /api/v1/repos/{owner}/{repo}/actions/secrets answers 200" do
    Factory[:secret]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
