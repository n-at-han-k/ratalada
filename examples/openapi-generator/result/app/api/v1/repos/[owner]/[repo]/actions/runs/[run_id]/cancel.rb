# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/runs/{run_id}/cancel -- scaffolded from the document.

# Cancel a pending or running workflow run.
post "/" do
  # params: owner, repo, run_id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/runs/{run_id}/cancel", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/runs/{run_id}/cancel" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :run_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Cancel a pending or running workflow run." do
      tags "repository"
      operationId "CancelActionRun"
      response 204, "Workflow run has been cancelled"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/actions/runs/{run_id}/cancel answers 204" do
    assert_api_response :post, 204, path_params: {owner: "owner", repo: "repo", run_id: 0}
  end
end
