# frozen_string_literal: true
# /admin/users/{username} -- scaffolded from the document.

# Delete user account
delete "/" do
  # params: username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Edit an existing user
patch "/" do
  # params: username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
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

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/users/{username}", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users/{username}" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    delete "Delete user account" do
      tags "admin"
      operationId "adminDeleteUser"
      parameter name: :purge, in: :query, schema: {"type" => "boolean"}, required: false
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    patch "Edit an existing user" do
      tags "admin"
      operationId "adminEditUser"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditUserOption}},
      )
      response 200, "User" do
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

  it "DELETE /api/v1/admin/users/{username} answers 204" do
    assert_api_response :delete, 204, path_params: {username: "username"}
  end

  it "PATCH /api/v1/admin/users/{username} answers 200" do
    assert_api_response :patch, 200, path_params: {username: "username"}, body: {
      "active" => false,
      "admin" => false,
      "allow_create_organization" => false,
      "allow_git_hook" => false,
      "allow_import_local" => false,
      "description" => "",
      "email" => "someone@example.com",
      "full_name" => "",
      "hide_email" => false,
      "location" => "",
      "login_name" => "",
      "max_repo_creation" => 0,
      "must_change_password" => false,
      "password" => "",
      "prohibit_login" => false,
      "pronouns" => "",
      "restricted" => false,
      "source_id" => 0,
      "visibility" => "",
      "website" => "",
    }
  end
end
