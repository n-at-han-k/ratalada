# frozen_string_literal: true
# /teams/{id}/members/{username} -- scaffolded from the document.

# Add a team member
put "/" do
  # params: id, username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# List a particular member of team
get "/" do
  # params: id, username
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

# Remove a team member
delete "/" do
  # params: id, username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/teams/{id}/members/{username}", type: :openapi do
  openapi_schema :public_api

  api_path "/teams/{id}/members/{username}" do
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "List a particular member of team" do
      tags "organization"
      operationId "orgListTeamMember"
      response 200, "User" do
        schema(Schemas::User)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Add a team member" do
      tags "organization"
      operationId "orgAddTeamMember"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    delete "Remove a team member" do
      tags "organization"
      operationId "orgRemoveTeamMember"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/teams/{id}/members/{username} answers 200" do
    assert_api_response :get, 200, path_params: {id: 0, username: "username"}
  end

  it "PUT /api/v1/teams/{id}/members/{username} answers 204" do
    assert_api_response :put, 204, path_params: {id: 0, username: "username"}
  end

  it "DELETE /api/v1/teams/{id}/members/{username} answers 204" do
    assert_api_response :delete, 204, path_params: {id: 0, username: "username"}
  end
end
