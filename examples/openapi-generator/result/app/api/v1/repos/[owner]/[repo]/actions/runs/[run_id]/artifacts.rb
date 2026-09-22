# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/runs/{run_id}/artifacts -- scaffolded from the document.

# List artifacts of a workflow run
get "/" do
  content_type(:json)
  status(200)
  relations[:action_artifact].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/runs/{run_id}/artifacts", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/runs/{run_id}/artifacts" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :run_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List artifacts of a workflow run" do
      tags "repository"
      operationId "ListActionRunArtifacts"
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
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/actions/runs/{run_id}/artifacts answers 200" do
    Factory[:action_artifact]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", run_id: 0}
  end
end
