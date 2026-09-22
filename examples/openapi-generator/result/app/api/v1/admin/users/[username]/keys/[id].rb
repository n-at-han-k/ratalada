# frozen_string_literal: true
# /admin/users/{username}/keys/{id} -- scaffolded from the document.

# Remove a public key from user's account
delete "/" do
  # params: username, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/users/{username}/keys/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users/{username}/keys/{id}" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    delete "Remove a public key from user's account" do
      tags "admin"
      operationId "adminDeleteUserPublicKey"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "DELETE /api/v1/admin/users/{username}/keys/{id} answers 204" do
    assert_api_response :delete, 204, path_params: {username: "username", id: 0}
  end
end
