# frozen_string_literal: true
# /repos/{owner}/{repo}/releases/latest -- scaffolded from the document.

# Gets the most recent non-prerelease, non-draft release of a repository, sorted by created_at
get "/" do
  # params: owner, repo
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
RSpec.describe "/repos/{owner}/{repo}/releases/latest", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/releases/latest" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Gets the most recent non-prerelease, non-draft release of a repository, sorted by created_at" do
      tags "repository"
      operationId "repoGetLatestRelease"
      response 200, "Release" do
        schema(Schemas::Release)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/releases/latest answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
