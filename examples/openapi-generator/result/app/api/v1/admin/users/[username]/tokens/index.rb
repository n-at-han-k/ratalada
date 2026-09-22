# frozen_string_literal: true
# /admin/users/{username}/tokens -- scaffolded from the document.

# Create an access token for the specified user
post "/" do
  # params: username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
  {}.to_json
end

# List the specified user's access tokens
get "/" do
  content_type(:json)
  status(200)
  relations[:access_token].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/users/{username}/tokens", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users/{username}/tokens" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "List the specified user's access tokens" do
      tags "admin"
      operationId "adminListUserAccessTokens"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "AccessTokenList" do
        schema({
  "type" => "array",
  "items" => Schemas::AccessToken,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create an access token for the specified user" do
      tags "admin"
      operationId "adminCreateUserAccessToken"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateAccessTokenOption}},
      )
      response 201, "AccessToken represents an API access token."
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

  it "GET /api/v1/admin/users/{username}/tokens answers 200" do
    Factory[:access_token]
    assert_api_response :get, 200, path_params: {username: "username"}
  end

  it "POST /api/v1/admin/users/{username}/tokens answers 201" do
    assert_api_response :post, 201, path_params: {username: "username"}, body: {
      "name" => "",
      "repositories" => [{"name" => "", "owner" => ""}],
      "scopes" => [""],
    }
  end
end
