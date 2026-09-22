# frozen_string_literal: true
# /repos/{owner}/{repo}/commits -- scaffolded from the document.

# Get a list of all commits from a repository
get "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "author" => {
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
      "commit" => {
        "author" => {
          "date" => "",
          "email" => "someone@example.com",
          "name" => "",
        },
        "committer" => {
          "date" => "",
          "email" => "someone@example.com",
          "name" => "",
        },
        "message" => "",
        "tree" => {
          "created" => "2026-01-01T00:00:00Z",
          "sha" => "",
          "url" => "",
        },
        "url" => "",
        "verification" => {
          "payload" => "",
          "reason" => "",
          "signature" => "",
          "signer" => {
            "email" => "someone@example.com",
            "name" => "",
            "username" => "",
          },
          "verified" => false,
        },
      },
      "committer" => {
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
      "created" => "2026-01-01T00:00:00Z",
      "files" => [{"filename" => "", "status" => ""}],
      "html_url" => "",
      "parents" => [
        {
          "created" => "2026-01-01T00:00:00Z",
          "sha" => "",
          "url" => "",
        },
      ],
      "sha" => "",
      "stats" => {"additions" => 0, "deletions" => 0, "total" => 0},
      "url" => "",
    },
  ].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/commits", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/commits" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get a list of all commits from a repository" do
      tags "repository"
      operationId "repoGetAllCommits"
      parameter name: :sha, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :path, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :stat, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :verification, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :files, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :not, in: :query, schema: {"type" => "string"}, required: false
      response 200, "CommitList" do
        schema({
  "type" => "array",
  "items" => Schemas::Commit,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "EmptyRepository" do
        schema(Schemas::APIError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/commits answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
