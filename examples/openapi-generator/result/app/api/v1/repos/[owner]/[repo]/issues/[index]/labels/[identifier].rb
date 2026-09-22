# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/labels/{identifier} -- scaffolded from the document.

# Remove a label from an issue
delete "/" do
  # params: owner, repo, index, identifier
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/labels/{identifier}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/labels/{identifier}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :identifier, in: :path, schema: {"type" => "string"}, required: true

    delete "Remove a label from an issue" do
      tags "issue"
      operationId "issueRemoveLabel"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::DeleteLabelsOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/labels/{identifier} answers 204" do
    assert_api_response :delete, 204, path_params: {
      :owner => "owner",
      :repo => "repo",
      :index => 0,
      :identifier => "identifier",
    }, body: {"updated_at" => "2026-01-01T00:00:00Z"}
  end
end
