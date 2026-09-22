# frozen_string_literal: true
# /repos/{owner}/{repo}/raw/{filepath} -- scaffolded from the document.

# Get a file from a repository
get "/" do
  # params: owner, repo, filepath
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  "".to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/raw/{filepath}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/raw/{filepath}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :filepath, in: :path, schema: {"type" => "string"}, required: true

    get "Get a file from a repository" do
      tags "repository"
      operationId "repoGetRawFile"
      parameter name: :ref, in: :query, schema: {"type" => "string"}, required: false
      response 200, "Returns raw file content." do
        schema({"type" => "string", "format" => "binary"})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/raw/{filepath} answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", filepath: "filepath"}
  end
end
