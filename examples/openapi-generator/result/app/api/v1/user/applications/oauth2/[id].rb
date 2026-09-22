# frozen_string_literal: true
# /user/applications/oauth2/{id} -- scaffolded from the document.

# Delete an OAuth2 application
delete "/" do
  # params: id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Get an OAuth2 application
get "/" do
  # params: id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

# Update an OAuth2 application, this includes regenerating the client secret
patch "/" do
  # params: id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/applications/oauth2/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/user/applications/oauth2/{id}" do
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get an OAuth2 application" do
      tags "user"
      operationId "userGetOAuth2Application"
      response 200, "OAuth2Application represents an OAuth2 application."
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

    delete "Delete an OAuth2 application" do
      tags "user"
      operationId "userDeleteOAuth2Application"
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

    patch "Update an OAuth2 application, this includes regenerating the client secret" do
      tags "user"
      operationId "userUpdateOAuth2Application"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::CreateOAuth2ApplicationOptions}},
      )
      response 200, "OAuth2Application represents an OAuth2 application."
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

  it "GET /api/v1/user/applications/oauth2/{id} answers 200" do
    assert_api_response :get, 200, path_params: {id: 0}
  end

  it "DELETE /api/v1/user/applications/oauth2/{id} answers 204" do
    assert_api_response :delete, 204, path_params: {id: 0}
  end

  it "PATCH /api/v1/user/applications/oauth2/{id} answers 200" do
    assert_api_response :patch, 200, path_params: {id: 0}, body: {
      "confidential_client" => false,
      "name" => "",
      "redirect_uris" => [""],
    }
  end
end
