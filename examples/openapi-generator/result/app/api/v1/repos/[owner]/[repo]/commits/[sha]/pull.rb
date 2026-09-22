# frozen_string_literal: true
# /repos/{owner}/{repo}/commits/{sha}/pull -- scaffolded from the document.

# Get the pull request of the commit
get "/" do
  content_type(:json)
  record = relations[:pull_request].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/commits/{sha}/pull", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/commits/{sha}/pull" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :sha, in: :path, schema: {"type" => "string"}, required: true

    get "Get the pull request of the commit" do
      tags "repository"
      operationId "repoGetCommitPullRequest"
      response 200, "PullRequest" do
        schema(Schemas::PullRequest)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/commits/{sha}/pull answers 200" do
    Factory[:pull_request]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", sha: "sha"}
  end
end
