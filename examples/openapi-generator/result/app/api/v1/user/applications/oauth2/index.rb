# frozen_string_literal: true
# /user/applications/oauth2 -- scaffolded from the document.

# Creates a new OAuth2 application
post "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
  {}.to_json
end

# List the authenticated user's oauth2 applications
get "/" do
  content_type(:json)
  status(200)
  relations[:o_auth2_application].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/applications/oauth2", type: :openapi do
  openapi_schema :public_api

  api_path "/user/applications/oauth2" do

    get "List the authenticated user's oauth2 applications" do
      tags "user"
      operationId "userGetOAuth2Applications"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "OAuth2ApplicationList represents a list of OAuth2 applications." do
        schema({
  "type" => "array",
  "items" => Schemas::OAuth2Application,
})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    post "Creates a new OAuth2 application" do
      tags "user"
      operationId "userCreateOAuth2Application"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::CreateOAuth2ApplicationOptions}},
      )
      response 201, "OAuth2Application represents an OAuth2 application."
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/user/applications/oauth2 answers 200" do
    Factory[:o_auth2_application]
    assert_api_response :get, 200
  end

  it "POST /api/v1/user/applications/oauth2 answers 201" do
    assert_api_response :post, 201, body: {
      "confidential_client" => false,
      "name" => "",
      "redirect_uris" => [""],
    }
  end
end
