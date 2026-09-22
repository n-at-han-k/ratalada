# frozen_string_literal: true
# /users/search -- scaffolded from the document.

# Search for users
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {
    "data" => [
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
    ],
    "ok" => false,
  }.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/users/search", type: :openapi do
  openapi_schema :public_api

  api_path "/users/search" do

    get "Search for users" do
      tags "user"
      operationId "userSearch"
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :uid, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :sort, in: :query, schema: {
  "type" => "string",
  "enum" => [
    "oldest",
    "newest",
    "alphabetically",
    "reversealphabetically",
    "recentupdate",
    "leastupdate",
  ],
}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "SearchResults of a successful search" do
        schema({
  "type" => "object",
  "title" => "UserSearchResults",
  "properties" => {
    "data" => {
      "type" => "array",
      "items" => Schemas::User,
    },
    "ok" => {"type" => "boolean"},
  },
})
      end
    end
  end

  it "GET /api/v1/users/search answers 200" do
    assert_api_response :get, 200
  end
end
