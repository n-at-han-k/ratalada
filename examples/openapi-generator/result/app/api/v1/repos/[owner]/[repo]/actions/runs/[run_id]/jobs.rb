# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/runs/{run_id}/jobs -- scaffolded from the document.

# List jobs of a workflow run
get "/" do
  content_type(:json)
  status(200)
  relations[:action_run_job].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/runs/{run_id}/jobs", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/runs/{run_id}/jobs" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :run_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List jobs of a workflow run" do
      tags "repository"
      operationId "ListActionRunJobs"
      response 200, "ActionRunJobList" do
        schema({
  "type" => "array",
  "items" => Schemas::ActionRunJob,
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

  it "GET /api/v1/repos/{owner}/{repo}/actions/runs/{run_id}/jobs answers 200" do
    Factory[:action_run_job]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", run_id: 0}
  end
end
