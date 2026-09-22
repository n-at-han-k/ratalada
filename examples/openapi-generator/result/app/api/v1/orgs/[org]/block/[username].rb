# frozen_string_literal: true
# /orgs/{org}/block/{username} -- scaffolded from the document.

# Blocks a user from the organization
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
RSpec.describe "/orgs/{org}/block/{username}", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/block/{username}" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    put "Blocks a user from the organization" do
      tags "organization"
      operationId "orgBlockUser"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "PUT /api/v1/orgs/{org}/block/{username} answers 204" do
    assert_api_response :put, 204, path_params: {org: "org", username: "username"}
  end
end
