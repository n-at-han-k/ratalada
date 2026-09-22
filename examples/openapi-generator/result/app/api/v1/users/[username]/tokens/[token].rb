# frozen_string_literal: true
# /users/{username}/tokens/{token} -- scaffolded from the document.

# Delete an access token from the specified user's account
delete "/" do
  # params: username, token
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/users/{username}/tokens/{token}", type: :openapi do
  openapi_schema :public_api

  api_path "/users/{username}/tokens/{token}" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :token, in: :path, schema: {"type" => "string"}, required: true

    delete "Delete an access token from the specified user's account" do
      tags "user"
      operationId "userDeleteAccessToken"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIError is error format response" do
        schema(Schemas::APIError)
      end
    end
  end

  it "DELETE /api/v1/users/{username}/tokens/{token} answers 204" do
    assert_api_response :delete, 204, path_params: {username: "username", token: "token"}
  end
end
