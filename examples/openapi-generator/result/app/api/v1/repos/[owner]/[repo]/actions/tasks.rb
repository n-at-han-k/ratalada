# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/tasks -- scaffolded from the document.

# List a repository's action tasks
get "/" do
  content_type(:json)
  record = relations[:action_task_response].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/tasks", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/tasks" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repository's action tasks" do
      tags "repository"
      operationId "ListActionTasks"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
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
      response 200, "TasksList" do
        schema(Schemas::ActionTaskResponse)
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
      response 409, "APIConflict is a conflict empty response"
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/actions/tasks answers 200" do
    Factory[:action_task_response]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
