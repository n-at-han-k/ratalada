# frozen_string_literal: true
# /repos/{owner}/{repo}/labels -- scaffolded from the document.

# Create a label
post "/" do
  # params: owner, repo
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

# Get all of a repository's labels
get "/" do
  # params: owner, repo
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
RSpec.describe "/repos/{owner}/{repo}/labels", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/labels" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get all of a repository's labels" do
      tags "issue"
      operationId "issueListLabels"
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

    post "Create a label" do
      tags "issue"
      operationId "issueCreateLabel"
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

  it "GET /api/v1/repos/{owner}/{repo}/labels answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/labels answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
      "color" => "",
      "description" => "",
      "exclusive" => false,
      "is_archived" => false,
      "name" => "",
    }
  end
end
