# frozen_string_literal: true
# /admin/users/{username}/rename -- scaffolded from the document.

# Rename a user
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
RSpec.describe "/admin/users/{username}/rename", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users/{username}/rename" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    post "Rename a user" do
      tags "admin"
      operationId "adminRenameUser"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::RenameUserOption}},
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

  it "POST /api/v1/admin/users/{username}/rename answers 204" do
    assert_api_response :post, 204, path_params: {username: "username"}, body: {"new_username" => ""}
  end
end
