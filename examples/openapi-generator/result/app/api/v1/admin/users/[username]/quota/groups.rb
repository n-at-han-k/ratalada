# frozen_string_literal: true
# /admin/users/{username}/quota/groups -- scaffolded from the document.

# Set the user's quota groups to a given list.
post "/" do
  # params: username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/users/{username}/quota/groups", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users/{username}/quota/groups" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    post "Set the user's quota groups to a given list." do
      tags "admin"
      operationId "adminSetUserQuotaGroups"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::SetUserQuotaGroupsOptions}},
      )
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
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/admin/users/{username}/quota/groups answers 204" do
    assert_api_response :post, 204, path_params: {username: "username"}, body: {"groups" => [""]}
  end
end
