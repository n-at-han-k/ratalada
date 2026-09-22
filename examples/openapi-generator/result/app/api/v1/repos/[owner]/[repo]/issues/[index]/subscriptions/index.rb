# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/subscriptions -- scaffolded from the document.

# Get users who subscribed on an issue.
get "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "active" => false,
      "avatar_url" => "",
      "created" => "2026-01-01T00:00:00Z",
      "description" => "",
      "email" => "someone@example.com",
      "followers_count" => 0,
      "following_count" => 0,
      "full_name" => "",
      "html_url" => "",
      "id" => 0,
      "is_admin" => false,
      "language" => "",
      "last_login" => "2026-01-01T00:00:00Z",
      "location" => "",
      "login" => "",
      "login_name" => "",
      "prohibit_login" => false,
      "pronouns" => "",
      "restricted" => false,
      "source_id" => 0,
      "starred_repos_count" => 0,
      "visibility" => "",
      "website" => "",
    },
  ].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/subscriptions", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/subscriptions" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get users who subscribed on an issue." do
      tags "issue"
      operationId "issueSubscriptions"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "UserList" do
        schema({
  "type" => "array",
  "items" => Schemas::User,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index}/subscriptions answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
