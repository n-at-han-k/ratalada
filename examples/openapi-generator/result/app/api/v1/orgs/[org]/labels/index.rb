# frozen_string_literal: true
# /orgs/{org}/labels -- scaffolded from the document.

# Create a label for an organization
post "/" do
  # params: org
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
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

# List an organization's labels
get "/" do
  # params: org
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "color" => "",
      "description" => "",
      "exclusive" => false,
      "id" => 0,
      "is_archived" => false,
      "name" => "",
      "url" => "",
    },
  ].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/labels", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/labels" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "List an organization's labels" do
      tags "organization"
      operationId "orgListLabels"
      parameter name: :sort, in: :query, schema: {
  "type" => "string",
  "enum" => ["mostissues", "leastissues", "reversealphabetically"],
}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "LabelList" do
        schema({
  "type" => "array",
  "items" => Schemas::Label,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a label for an organization" do
      tags "organization"
      operationId "orgCreateLabel"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateLabelOption}},
      )
      response 201, "Label" do
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

  it "GET /api/v1/orgs/{org}/labels answers 200" do
    assert_api_response :get, 200, path_params: {org: "org"}
  end

  it "POST /api/v1/orgs/{org}/labels answers 201" do
    assert_api_response :post, 201, path_params: {org: "org"}, body: {
      "color" => "",
      "description" => "",
      "exclusive" => false,
      "is_archived" => false,
      "name" => "",
    }
  end
end
