# frozen_string_literal: true
# /admin/users/{username}/emails -- scaffolded from the document.

# Delete email addresses from a user's account
delete "/" do
  # params: username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# List all email addresses for a user
get "/" do
  content_type(:json)
  status(200)
  relations[:email].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/users/{username}/emails", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users/{username}/emails" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "List all email addresses for a user" do
      tags "admin"
      operationId "adminListUserEmails"
      response 200, "EmailList" do
        schema({
  "type" => "array",
  "items" => Schemas::Email,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete email addresses from a user's account" do
      tags "admin"
      operationId "adminDeleteUserEmails"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::DeleteEmailOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/admin/users/{username}/emails answers 200" do
    Factory[:email]
    assert_api_response :get, 200, path_params: {username: "username"}
  end

  it "DELETE /api/v1/admin/users/{username}/emails answers 204" do
    assert_api_response :delete, 204, path_params: {username: "username"}, body: {"emails" => [""]}
  end
end
