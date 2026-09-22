# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/comments/{id} -- scaffolded from the document.

# Delete a comment
delete "/" do
  # params: owner, repo, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Edit a comment
patch "/" do
  # params: owner, repo, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
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
  }.to_json
end

# Get a comment
get "/" do
  # params: owner, repo, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
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
  }.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/comments/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/comments/{id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a comment" do
      tags "issue"
      operationId "issueGetComment"
      response 200, "Comment" do
        schema(Schemas::Comment)
      end
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 500, "APIInternalServerError is an error that is raised when an internal server error occurs" do
        schema(Schemas::APIInternalServerError)
      end
    end

    delete "Delete a comment" do
      tags "issue"
      operationId "issueDeleteComment"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 500, "APIInternalServerError is an error that is raised when an internal server error occurs" do
        schema(Schemas::APIInternalServerError)
      end
    end

    patch "Edit a comment" do
      tags "issue"
      operationId "issueEditComment"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditIssueCommentOption}},
      )
      response 200, "Comment" do
        schema(Schemas::Comment)
      end
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
      response 500, "APIInternalServerError is an error that is raised when an internal server error occurs" do
        schema(Schemas::APIInternalServerError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/comments/{id} answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", id: 1}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/comments/{id} answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", id: 1}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/issues/comments/{id} answers 200" do
    assert_api_response :patch, 200, path_params: {owner: "owner", repo: "repo", id: 1}, body: {"body" => "", "updated_at" => "2026-01-01T00:00:00Z"}
  end
end
