# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/runs -- scaffolded from the document.

# List a repository's action runs
get "/" do
  content_type(:json)
  record = relations[:list_action_run_response].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/runs", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/runs" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repository's action runs" do
      tags "repository"
      operationId "ListActionRuns"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :event, in: :query, schema: {"type" => "array", "items" => {"type" => "string"}}, required: false
      parameter name: :status, in: :query, schema: {
  "type" => "array",
  "items" => {
    "enum" => [
      "unknown",
      "waiting",
      "running",
      "success",
      "failure",
      "cancelled",
      "skipped",
      "blocked",
    ],
    "type" => "string",
  },
}, required: false
      parameter name: :run_number, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :head_sha, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :ref, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :workflow_id, in: :query, schema: {"type" => "string"}, required: false
      response 200, "ActionRunList" do
        schema(Schemas::ListActionRunResponse)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/actions/runs answers 200" do
    Factory[:list_action_run_response]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
