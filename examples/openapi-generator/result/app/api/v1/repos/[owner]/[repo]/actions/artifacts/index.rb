# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/artifacts -- scaffolded from the document.

# List a repository's artifacts
get "/" do
  content_type(:json)
  status(200)
  relations[:action_artifact].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/artifacts", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/artifacts" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repository's artifacts" do
      tags "repository"
      operationId "ListActionArtifacts"
      parameter name: :name, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "ActionArtifactList" do
        schema({
  "type" => "array",
  "items" => Schemas::ActionArtifact,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/actions/artifacts answers 200" do
    Factory[:action_artifact]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
