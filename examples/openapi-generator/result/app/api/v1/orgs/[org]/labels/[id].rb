# frozen_string_literal: true
# /orgs/{org}/labels/{id} -- scaffolded from the document.

# Delete a label
delete "/" do
  # params: org, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Update a label
patch "/" do
  # params: org, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {
    "color" => "",
    "description" => "",
    "exclusive" => false,
    "id" => 0,
    "is_archived" => false,
    "name" => "",
    "url" => "",
  }.to_json
end

# Get a single label
get "/" do
  # params: org, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {
    "color" => "",
    "description" => "",
    "exclusive" => false,
    "id" => 0,
    "is_archived" => false,
    "name" => "",
    "url" => "",
  }.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/labels/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/labels/{id}" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a single label" do
      tags "organization"
      operationId "orgGetLabel"
      response 200, "Label" do
        schema(Schemas::Label)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a label" do
      tags "organization"
      operationId "orgDeleteLabel"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Update a label" do
      tags "organization"
      operationId "orgEditLabel"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditLabelOption}},
      )
      response 200, "Label" do
        schema(Schemas::Label)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/labels/{id} answers 200" do
    assert_api_response :get, 200, path_params: {org: "org", id: 1}
  end

  it "DELETE /api/v1/orgs/{org}/labels/{id} answers 204" do
    assert_api_response :delete, 204, path_params: {org: "org", id: 1}
  end

  it "PATCH /api/v1/orgs/{org}/labels/{id} answers 200" do
    assert_api_response :patch, 200, path_params: {org: "org", id: 1}, body: {
      "color" => "",
      "description" => "",
      "exclusive" => false,
      "is_archived" => false,
      "name" => "",
    }
  end
end
