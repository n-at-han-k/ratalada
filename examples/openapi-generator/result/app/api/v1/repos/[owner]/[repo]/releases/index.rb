# frozen_string_literal: true
# /repos/{owner}/{repo}/releases -- scaffolded from the document.

# Create a release
post "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
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

# List a repo's releases
get "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
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
    },
  ].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/releases", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/releases" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repo's releases" do
      tags "repository"
      operationId "repoListReleases"
      parameter name: :draft, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :"pre-release", in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "ReleaseList" do
        schema({
  "type" => "array",
  "items" => Schemas::Release,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a release" do
      tags "repository"
      operationId "repoCreateRelease"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateReleaseOption}},
      )
      response 201, "Release" do
        schema(Schemas::Release)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/releases answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/releases answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
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
