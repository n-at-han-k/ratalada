# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/jobs/{job_id} -- scaffolded from the document.

# Get a single workflow run job, including its step list
get "/" do
  content_type(:json)
  record = relations[:action_run_job].where(:job_id => params["job_id"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/jobs/{job_id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/jobs/{job_id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :job_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a single workflow run job, including its step list" do
      tags "repository"
      operationId "repoGetActionJob"
      response 200, "ActionRunJob is a single workflow run job" do
        schema(Schemas::ActionRunJob)
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

  it "GET /api/v1/repos/{owner}/{repo}/actions/jobs/{job_id} answers 200" do
    Factory[:action_run_job, :job_id => 0]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", job_id: 0}
  end
end
