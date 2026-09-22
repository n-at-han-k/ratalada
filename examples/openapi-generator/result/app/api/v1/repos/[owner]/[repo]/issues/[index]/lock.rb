# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/lock -- scaffolded from the document.

# Lock an issue
put "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Unlock an issue
delete "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/lock", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/lock" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    put "Lock an issue" do
      tags "issue"
      operationId "lockIssue"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::IssueLockOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "APIConflict is a conflict empty response"
    end

    delete "Unlock an issue" do
      tags "issue"
      operationId "unlockIssue"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "APIConflict is a conflict empty response"
    end
  end

  it "PUT /api/v1/repos/{owner}/{repo}/issues/{index}/lock answers 204" do
    assert_api_response :put, 204, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"reason" => ""}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/lock answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
