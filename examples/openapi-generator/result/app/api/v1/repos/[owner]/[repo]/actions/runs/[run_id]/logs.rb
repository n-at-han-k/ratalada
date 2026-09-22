# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/runs/{run_id}/logs -- scaffolded from the document.

# Download a ZIP of plaintext logs for every job in an action run
get "/" do
  # params: owner, repo, run_id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  "".to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/runs/{run_id}/logs", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/runs/{run_id}/logs" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :run_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Download a ZIP of plaintext logs for every job in an action run" do
      tags "repository"
      operationId "repoGetActionRunLogs"
      response 200, "ZIP archive of per-job log files" do
        schema({"type" => "string", "format" => "binary"})
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

  it "GET /api/v1/repos/{owner}/{repo}/actions/runs/{run_id}/logs answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", run_id: 0}
  end
end
