# frozen_string_literal: true
# /repos/{owner}/{repo}/releases/{id} -- scaffolded from the document.

# Delete a release
delete "/" do
  # params: owner, repo, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Update a release
patch "/" do
  # params: owner, repo, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {
    "archive_download_count" => {"tar_gz" => 0, "zip" => 0},
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
    "body" => "",
    "created_at" => "2026-01-01T00:00:00Z",
    "draft" => false,
    "hide_archive_links" => false,
    "html_url" => "",
    "id" => 0,
    "name" => "",
    "prerelease" => false,
    "published_at" => "2026-01-01T00:00:00Z",
    "tag_name" => "",
    "tarball_url" => "",
    "target_commitish" => "",
    "upload_url" => "",
    "url" => "",
    "zipball_url" => "",
  }.to_json
end

# Get a release
get "/" do
  # params: owner, repo, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {
    "archive_download_count" => {"tar_gz" => 0, "zip" => 0},
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
    "body" => "",
    "created_at" => "2026-01-01T00:00:00Z",
    "draft" => false,
    "hide_archive_links" => false,
    "html_url" => "",
    "id" => 0,
    "name" => "",
    "prerelease" => false,
    "published_at" => "2026-01-01T00:00:00Z",
    "tag_name" => "",
    "tarball_url" => "",
    "target_commitish" => "",
    "upload_url" => "",
    "url" => "",
    "zipball_url" => "",
  }.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/releases/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/releases/{id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a release" do
      tags "repository"
      operationId "repoGetRelease"
      response 200, "Release" do
        schema(Schemas::Release)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a release" do
      tags "repository"
      operationId "repoDeleteRelease"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    patch "Update a release" do
      tags "repository"
      operationId "repoEditRelease"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditReleaseOption}},
      )
      response 200, "Release" do
        schema(Schemas::Release)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/releases/{id} answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", id: 1}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/releases/{id} answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", id: 1}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/releases/{id} answers 200" do
    assert_api_response :patch, 200, path_params: {owner: "owner", repo: "repo", id: 1}, body: {
      "body" => "",
      "draft" => false,
      "hide_archive_links" => false,
      "name" => "",
      "prerelease" => false,
      "tag_name" => "",
      "target_commitish" => "",
    }
  end
end
