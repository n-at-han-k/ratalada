# frozen_string_literal: true
# /repos/{owner}/{repo}/flags/{flag} -- scaffolded from the document.

# Add a flag to a repository
put "/" do
  # params: owner, repo, flag
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Check if a repository has a given flag
get "/" do
  # params: owner, repo, flag
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Remove a flag from a repository
delete "/" do
  # params: owner, repo, flag
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/flags/{flag}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/flags/{flag}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :flag, in: :path, schema: {"type" => "string"}, required: true

    get "Check if a repository has a given flag" do
      tags "repository"
      operationId "repoCheckFlag"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Add a flag to a repository" do
      tags "repository"
      operationId "repoAddFlag"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Remove a flag from a repository" do
      tags "repository"
      operationId "repoDeleteFlag"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/flags/{flag} answers 204" do
    assert_api_response :get, 204, path_params: {owner: "owner", repo: "repo", flag: "flag"}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/flags/{flag} answers 204" do
    assert_api_response :put, 204, path_params: {owner: "owner", repo: "repo", flag: "flag"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/flags/{flag} answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", flag: "flag"}
  end
end
