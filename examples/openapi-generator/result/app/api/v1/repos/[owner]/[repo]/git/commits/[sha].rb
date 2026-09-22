# frozen_string_literal: true
# /repos/{owner}/{repo}/git/commits/{sha} -- scaffolded from the document.

# Get a single commit from a repository
get "/" do
  # params: owner, repo, sha
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
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
  }.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/git/commits/{sha}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/git/commits/{sha}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :sha, in: :path, schema: {"type" => "string"}, required: true

    get "Get a single commit from a repository" do
      tags "repository"
      operationId "repoGetSingleCommit"
      parameter name: :stat, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :verification, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :files, in: :query, schema: {"type" => "boolean"}, required: false
      response 200, "Commit" do
        schema(Schemas::Commit)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/git/commits/{sha} answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", sha: "sha"}
  end
end
