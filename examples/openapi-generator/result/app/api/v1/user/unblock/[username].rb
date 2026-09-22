# frozen_string_literal: true
# /user/unblock/{username} -- scaffolded from the document.

# Unblocks a user from the doer
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
RSpec.describe "/user/unblock/{username}", type: :openapi do
  openapi_schema :public_api

  api_path "/user/unblock/{username}" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    put "Unblocks a user from the doer" do
      tags "user"
      operationId "userUnblockUser"
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
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "PUT /api/v1/user/unblock/{username} answers 204" do
    assert_api_response :put, 204, path_params: {username: "username"}
  end
end
