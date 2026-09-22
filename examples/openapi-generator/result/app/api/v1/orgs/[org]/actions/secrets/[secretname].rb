# frozen_string_literal: true
# /orgs/{org}/actions/secrets/{secretname} -- scaffolded from the document.

# Delete a secret in an organization
delete "/" do
  # params: org, secretname
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Create or Update a secret value in an organization
put "/" do
  # params: org, secretname
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/actions/secrets/{secretname}", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/actions/secrets/{secretname}" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :secretname, in: :path, schema: {"type" => "string"}, required: true

    put "Create or Update a secret value in an organization" do
      tags "organization"
      operationId "updateOrgSecret"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateOrUpdateSecretOption}},
      )
      response 201, "response when creating a secret"
      response 204, "response when updating a secret"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a secret in an organization" do
      tags "organization"
      operationId "deleteOrgSecret"
      response 204, "delete one secret of the organization"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "PUT /api/v1/orgs/{org}/actions/secrets/{secretname} answers 201" do
    assert_api_response :put, 201, path_params: {org: "org", secretname: "secretname"}, body: {"data" => ""}
  end

  it "DELETE /api/v1/orgs/{org}/actions/secrets/{secretname} answers 204" do
    assert_api_response :delete, 204, path_params: {org: "org", secretname: "secretname"}
  end
end
