# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/times/{id} -- scaffolded from the document.

# Delete specific tracked time
delete "/" do
  # params: owner, repo, index, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/times/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/times/{id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    delete "Delete specific tracked time" do
      tags "issue"
      operationId "issueDeleteTime"
      response 204, "APIEmpty is an empty response"
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

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/times/{id} answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0, id: 0}
  end
end
