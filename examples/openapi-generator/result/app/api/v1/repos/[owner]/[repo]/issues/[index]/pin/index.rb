# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/pin -- scaffolded from the document.

# Pin an Issue
post "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Unpin an Issue
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
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/pin", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/pin" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Pin an Issue" do
      tags "issue"
      operationId "pinIssue"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Unpin an Issue" do
      tags "issue"
      operationId "unpinIssue"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues/{index}/pin answers 204" do
    assert_api_response :post, 204, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/pin answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
