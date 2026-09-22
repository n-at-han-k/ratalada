# frozen_string_literal: true
# /user/following/{username} -- scaffolded from the document.

# Check whether a user is followed by the authenticated user
get "/" do
  # params: username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Unfollow a user
delete "/" do
  # params: username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Follow a user
put "/" do
  # params: username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/following/{username}", type: :openapi do
  openapi_schema :public_api

  api_path "/user/following/{username}" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "Check whether a user is followed by the authenticated user" do
      tags "user"
      operationId "userCurrentCheckFollowing"
      response 204, "APIEmpty is an empty response"
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Follow a user" do
      tags "user"
      operationId "userCurrentPutFollow"
      response 204, "APIEmpty is an empty response"
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Unfollow a user" do
      tags "user"
      operationId "userCurrentDeleteFollow"
      response 204, "APIEmpty is an empty response"
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/user/following/{username} answers 204" do
    assert_api_response :get, 204, path_params: {username: "username"}
  end

  it "PUT /api/v1/user/following/{username} answers 204" do
    assert_api_response :put, 204, path_params: {username: "username"}
  end

  it "DELETE /api/v1/user/following/{username} answers 204" do
    assert_api_response :delete, 204, path_params: {username: "username"}
  end
end
