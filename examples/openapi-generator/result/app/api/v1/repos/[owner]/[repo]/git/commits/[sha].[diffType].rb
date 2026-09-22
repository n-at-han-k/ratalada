# frozen_string_literal: true
# /repos/{owner}/{repo}/git/commits/{sha}.{diffType} -- scaffolded from the document.

# Get a commit's diff or patch
get "/" do
  # params: owner, repo, sha, diffType
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  "".to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/git/commits/{sha}.{diffType}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/git/commits/{sha}.{diffType}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :sha, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :diffType, in: :path, schema: {"type" => "string", "enum" => ["diff", "patch"]}, required: true

    get "Get a commit's diff or patch" do
      tags "repository"
      operationId "repoDownloadCommitDiffOrPatch"
      response 200, "APIString is a string response" do
        schema({"type" => "string"})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/git/commits/{sha}.{diffType} answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", sha: "sha", diffType: "diff"}
  end
end
