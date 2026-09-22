# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index}/update -- scaffolded from the document.

# Merge PR's baseBranch into headBranch
post "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}/update", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}/update" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Merge PR's baseBranch into headBranch" do
      tags "repository"
      operationId "repoUpdatePullRequest"
      parameter name: :style, in: :query, schema: {"type" => "string", "enum" => ["merge", "rebase"]}, required: false
      response 200, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 413, "QuotaExceeded"
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/pulls/{index}/update answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
