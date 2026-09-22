# frozen_string_literal: true
# /admin/users -- scaffolded from the document.

# Create a user account
post "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
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
  }.to_json
end

# Search users according filter conditions
get "/" do
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
RSpec.describe "/admin/users", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users" do

    get "Search users according filter conditions" do
      tags "admin"
      operationId "adminSearchUsers"
      parameter name: :source_id, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :login_name, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :is_2fa_enabled, in: :query, schema: {"type" => "boolean"}, required: false
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
      response 200, "UserList" do
        schema({
  "type" => "array",
  "items" => Schemas::User,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    post "Create a user account" do
      tags "admin"
      operationId "adminCreateUser"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateUserOption}},
      )
      response 201, "User" do
        schema(Schemas::User)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/admin/users answers 200" do
    assert_api_response :get, 200
  end

  it "POST /api/v1/admin/users answers 201" do
    assert_api_response :post, 201, body: {
      "created_at" => "2026-01-01T00:00:00Z",
      "email" => "someone@example.com",
      "full_name" => "",
      "login_name" => "",
      "must_change_password" => false,
      "password" => "",
      "restricted" => false,
      "send_notify" => false,
      "source_id" => 0,
      "username" => "",
      "visibility" => "",
    }
  end
end
