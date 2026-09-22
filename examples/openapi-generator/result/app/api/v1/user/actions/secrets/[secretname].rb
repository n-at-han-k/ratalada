# frozen_string_literal: true
# /user/actions/secrets/{secretname} -- scaffolded from the document.

# Delete a secret in a user scope
delete "/" do
  # params: secretname
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Create or Update a secret value in a user scope
put "/" do
  # params: secretname
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/actions/secrets/{secretname}", type: :openapi do
  openapi_schema :public_api

  api_path "/user/actions/secrets/{secretname}" do
    parameter name: :secretname, in: :path, schema: {"type" => "string"}, required: true

    put "Create or Update a secret value in a user scope" do
      tags "user"
      operationId "updateUserSecret"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateOrUpdateSecretOption}},
      )
      response 201, "response when creating a secret"
      response 204, "response when updating a secret"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
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

    delete "Delete a secret in a user scope" do
      tags "user"
      operationId "deleteUserSecret"
      response 204, "delete one secret of the user"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
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

  it "PUT /api/v1/user/actions/secrets/{secretname} answers 201" do
    assert_api_response :put, 201, path_params: {secretname: "secretname"}, body: {"data" => ""}
  end

  it "DELETE /api/v1/user/actions/secrets/{secretname} answers 204" do
    assert_api_response :delete, 204, path_params: {secretname: "secretname"}
  end
end
