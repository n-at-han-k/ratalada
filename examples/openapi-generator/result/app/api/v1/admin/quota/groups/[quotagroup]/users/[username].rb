# frozen_string_literal: true
# /admin/quota/groups/{quotagroup}/users/{username} -- scaffolded from the document.

# Add a user to a quota group
put "/" do
  # params: quotagroup, username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Remove a user from a quota group
delete "/" do
  # params: quotagroup, username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/quota/groups/{quotagroup}/users/{username}", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/quota/groups/{quotagroup}/users/{username}" do
    parameter name: :quotagroup, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    put "Add a user to a quota group" do
      tags "admin"
      operationId "adminAddUserToQuotaGroup"
      response 204, "APIEmpty is an empty response"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    delete "Remove a user from a quota group" do
      tags "admin"
      operationId "adminRemoveUserFromQuotaGroup"
      response 204, "APIEmpty is an empty response"
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

  it "PUT /api/v1/admin/quota/groups/{quotagroup}/users/{username} answers 204" do
    assert_api_response :put, 204, path_params: {quotagroup: "quotagroup", username: "username"}
  end

  it "DELETE /api/v1/admin/quota/groups/{quotagroup}/users/{username} answers 204" do
    assert_api_response :delete, 204, path_params: {quotagroup: "quotagroup", username: "username"}
  end
end
