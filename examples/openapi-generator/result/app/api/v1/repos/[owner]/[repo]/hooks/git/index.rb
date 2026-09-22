# frozen_string_literal: true
# /repos/{owner}/{repo}/hooks/git -- scaffolded from the document.

# List the Git hooks in a repository
get "/" do
  content_type(:json)
  status(200)
  relations[:git_hook].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/hooks/git", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/hooks/git" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List the Git hooks in a repository" do
      tags "repository"
      operationId "repoListGitHooks"
      response 200, "GitHookList" do
        schema({
  "type" => "array",
  "items" => Schemas::GitHook,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/hooks/git answers 200" do
    Factory[:git_hook]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
