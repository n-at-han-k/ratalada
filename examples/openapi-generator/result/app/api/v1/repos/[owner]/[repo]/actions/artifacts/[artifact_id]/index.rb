# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/artifacts/{artifact_id} -- scaffolded from the document.

# Mark an artifact for deletion
delete "/" do
  records = relations[:action_artifact].where(:artifact_id => params["artifact_id"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get an artifact by ID
get "/" do
  content_type(:json)
  record = relations[:action_artifact].where(:artifact_id => params["artifact_id"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/artifacts/{artifact_id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/artifacts/{artifact_id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :artifact_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get an artifact by ID" do
      tags "repository"
      operationId "GetActionArtifact"
      response 200, "ActionArtifact" do
        schema(Schemas::ActionArtifact)
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

    delete "Mark an artifact for deletion" do
      tags "repository"
      operationId "DeleteActionArtifact"
      response 204, "artifact marked for deletion"
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

  it "GET /api/v1/repos/{owner}/{repo}/actions/artifacts/{artifact_id} answers 200" do
    Factory[:action_artifact, :artifact_id => 0]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", artifact_id: 0}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/actions/artifacts/{artifact_id} answers 204" do
    Factory[:action_artifact, :artifact_id => 0]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", artifact_id: 0}
  end
end
