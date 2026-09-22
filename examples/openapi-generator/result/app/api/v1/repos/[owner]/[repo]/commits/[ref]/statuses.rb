# frozen_string_literal: true
# /repos/{owner}/{repo}/commits/{ref}/statuses -- scaffolded from the document.

# Get a commit's statuses, by branch/tag/commit reference
get "/" do
  content_type(:json)
  status(200)
  relations[:commit_status].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/commits/{ref}/statuses", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/commits/{ref}/statuses" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :ref, in: :path, schema: {"type" => "string"}, required: true

    get "Get a commit's statuses, by branch/tag/commit reference" do
      tags "repository"
      operationId "repoListStatusesByRef"
      parameter name: :sort, in: :query, schema: {
  "type" => "string",
  "enum" => [
    "oldest",
    "recentupdate",
    "leastupdate",
    "leastindex",
    "highestindex",
  ],
}, required: false
      parameter name: :state, in: :query, schema: {
  "type" => "string",
  "enum" => ["pending", "success", "error", "failure", "warning"],
}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "CommitStatusList" do
        schema({
  "type" => "array",
  "items" => Schemas::CommitStatus,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/commits/{ref}/statuses answers 200" do
    Factory[:commit_status]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", ref: "ref"}
  end
end
