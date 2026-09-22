# frozen_string_literal: true
# /admin/quota/groups/{quotagroup}/users -- scaffolded from the document.

# List users in a quota group
get "/" do
  # params: quotagroup
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
RSpec.describe "/admin/quota/groups/{quotagroup}/users", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/quota/groups/{quotagroup}/users" do
    parameter name: :quotagroup, in: :path, schema: {"type" => "string"}, required: true

    get "List users in a quota group" do
      tags "admin"
      operationId "adminListUsersInQuotaGroup"
      response 200, "UserList" do
        schema({
  "type" => "array",
  "items" => Schemas::User,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/admin/quota/groups/{quotagroup}/users answers 200" do
    assert_api_response :get, 200, path_params: {quotagroup: "quotagroup"}
  end
end
