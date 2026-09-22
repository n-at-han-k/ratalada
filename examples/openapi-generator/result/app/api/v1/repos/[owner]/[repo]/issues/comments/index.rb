# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/comments -- scaffolded from the document.

# List all comments in a repository
get "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "assets" => [
        {
          "browser_download_url" => "",
          "created_at" => "2026-01-01T00:00:00Z",
          "download_count" => 0,
          "id" => 0,
          "name" => "",
          "size" => 0,
          "type" => "attachment",
          "uuid" => "",
        },
      ],
      "body" => "",
      "created_at" => "2026-01-01T00:00:00Z",
      "html_url" => "",
      "id" => 0,
      "issue_url" => "",
      "original_author" => "",
      "original_author_id" => 0,
      "pull_request_url" => "",
      "updated_at" => "2026-01-01T00:00:00Z",
      "user" => {
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
    },
  ].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/comments", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/comments" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List all comments in a repository" do
      tags "issue"
      operationId "issueGetRepoComments"
      parameter name: :since, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :before, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "CommentList" do
        schema({
  "type" => "array",
  "items" => Schemas::Comment,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
      response 500, "APIInternalServerError is an error that is raised when an internal server error occurs" do
        schema(Schemas::APIInternalServerError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/comments answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
