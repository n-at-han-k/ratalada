# frozen_string_literal: true
# /repos/{owner}/{repo}/flags -- scaffolded from the document.

# Remove all flags from a repository
delete "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# List a repository's flags
get "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [""].to_json
end

# Replace all flags of a repository
put "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/flags", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/flags" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repository's flags" do
      tags "repository"
      operationId "repoListFlags"
      response 200, "StringSlice" do
        schema({"type" => "array", "items" => {"type" => "string"}})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Replace all flags of a repository" do
      tags "repository"
      operationId "repoReplaceAllFlags"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::ReplaceFlagsOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Remove all flags from a repository" do
      tags "repository"
      operationId "repoDeleteAllFlags"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/flags answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/flags answers 204" do
    assert_api_response :put, 204, path_params: {owner: "owner", repo: "repo"}, body: {"flags" => [""]}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/flags answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo"}
  end
end
