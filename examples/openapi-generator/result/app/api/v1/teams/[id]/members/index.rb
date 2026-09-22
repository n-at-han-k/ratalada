# frozen_string_literal: true
# /teams/{id}/members -- scaffolded from the document.

# List a team's members
get "/" do
  # params: id
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
RSpec.describe "/teams/{id}/members", type: :openapi do
  openapi_schema :public_api

  api_path "/teams/{id}/members" do
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List a team's members" do
      tags "organization"
      operationId "orgListTeamMembers"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "UserList" do
        schema({
  "type" => "array",
  "items" => Schemas::User,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/teams/{id}/members answers 200" do
    assert_api_response :get, 200, path_params: {id: 0}
  end
end
