# frozen_string_literal: true
# /users/{username}/following/{target} -- scaffolded from the document.

# Check if one user is following another user
get "/" do
  # params: username, target
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/users/{username}/following/{target}", type: :openapi do
  openapi_schema :public_api

  api_path "/users/{username}/following/{target}" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :target, in: :path, schema: {"type" => "string"}, required: true

    get "Check if one user is following another user" do
      tags "user"
      operationId "userCheckFollowing"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/users/{username}/following/{target} answers 204" do
    assert_api_response :get, 204, path_params: {username: "username", target: "target"}
  end
end
