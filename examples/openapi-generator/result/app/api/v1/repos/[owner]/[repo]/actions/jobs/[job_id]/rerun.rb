# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/jobs/{job_id}/rerun -- scaffolded from the document.

# Rerun a completed workflow job and its dependent jobs
post "/" do
  # params: owner, repo, job_id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/jobs/{job_id}/rerun", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/jobs/{job_id}/rerun" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :job_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Rerun a completed workflow job and its dependent jobs" do
      tags "repository"
      operationId "repoRerunActionJob"
      response 204, "Workflow job rerun has been started"
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

  it "POST /api/v1/repos/{owner}/{repo}/actions/jobs/{job_id}/rerun answers 204" do
    assert_api_response :post, 204, path_params: {owner: "owner", repo: "repo", job_id: 0}
  end
end
