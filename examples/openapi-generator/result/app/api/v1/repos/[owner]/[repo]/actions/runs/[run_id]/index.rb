# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/runs/{run_id} -- scaffolded from the document.

# Get an action run
get "/" do
  content_type(:json)
  record = relations[:action_run].where(:run_id => params["run_id"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Delete a completed workflow run.
delete "/" do
  records = relations[:action_run].where(:run_id => params["run_id"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/runs/{run_id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/runs/{run_id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :run_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get an action run" do
      tags "repository"
      operationId "ActionRun"
      response 200, "ActionRun" do
        schema(Schemas::ActionRun)
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

    delete "Delete a completed workflow run." do
      tags "repository"
      operationId "DeleteActionRun"
      response 204, "Workflow run has been removed"
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

  it "GET /api/v1/repos/{owner}/{repo}/actions/runs/{run_id} answers 200" do
    Factory[:action_run, :run_id => 0]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", run_id: 0}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/actions/runs/{run_id} answers 204" do
    Factory[:action_run, :run_id => 0]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", run_id: 0}
  end
end
