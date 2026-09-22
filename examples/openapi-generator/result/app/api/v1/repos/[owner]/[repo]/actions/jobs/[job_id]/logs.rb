# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/jobs/{job_id}/logs -- scaffolded from the document.

# Download the plaintext logs of an action job
get "/" do
  # params: owner, repo, job_id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  "".to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/jobs/{job_id}/logs", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/jobs/{job_id}/logs" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :job_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Download the plaintext logs of an action job" do
      tags "repository"
      operationId "repoGetActionJobLogs"
      parameter name: :attempt, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :step, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :qi, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :format, in: :query, schema: {"type" => "string", "enum" => ["text", "ndjson"]}, required: false
      response 200, "Plaintext log content (or NDJSON when `format=ndjson`)" do
        schema({"type" => "string"})
      end
      response 206, "Partial log content (Range request; not returned when `q` or `format=ndjson` is set)" do
        schema({"type" => "string"})
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

  it "GET /api/v1/repos/{owner}/{repo}/actions/jobs/{job_id}/logs answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", job_id: 0}
  end
end
