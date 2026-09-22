# frozen_string_literal: true
# /orgs/{org}/public_members/{username} -- scaffolded from the document.

# Conceal a user's membership
delete "/" do
  # params: org, username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Check if a user is a public member of an organization
get "/" do
  # params: org, username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Publicize a user's membership
put "/" do
  # params: org, username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/public_members/{username}", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/public_members/{username}" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "Check if a user is a public member of an organization" do
      tags "organization"
      operationId "orgIsPublicMember"
      response 204, "user is a public member"
      response 404, "user is not a public member"
    end

    put "Publicize a user's membership" do
      tags "organization"
      operationId "orgPublicizeMember"
      response 204, "membership publicized"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Conceal a user's membership" do
      tags "organization"
      operationId "orgConcealMember"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/public_members/{username} answers 204" do
    assert_api_response :get, 204, path_params: {org: "org", username: "username"}
  end

  it "PUT /api/v1/orgs/{org}/public_members/{username} answers 204" do
    assert_api_response :put, 204, path_params: {org: "org", username: "username"}
  end

  it "DELETE /api/v1/orgs/{org}/public_members/{username} answers 204" do
    assert_api_response :delete, 204, path_params: {org: "org", username: "username"}
  end
end
