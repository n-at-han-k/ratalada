# frozen_string_literal: true
# /orgs/{org}/repos -- scaffolded from the document.

# Create a repository in an organization
post "/" do
  content_type(:json)
  records = relations[:repository]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List an organization's repos
get "/" do
  content_type(:json)
  status(200)
  relations[:repository].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/repos", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/repos" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "List an organization's repos" do
      tags "organization"
      operationId "orgListRepos"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "RepositoryList" do
        schema({
  "type" => "array",
  "items" => Schemas::Repository,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a repository in an organization" do
      tags "organization"
      operationId "createOrgRepo"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateRepoOption}},
      )
      response 201, "Repository" do
        schema(Schemas::Repository)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/repos answers 200" do
    Factory[:repository]
    assert_api_response :get, 200, path_params: {org: "org"}
  end

  it "POST /api/v1/orgs/{org}/repos answers 201" do
    assert_api_response :post, 201, path_params: {org: "org"}, body: {
      "auto_init" => false,
      "default_branch" => "",
      "description" => "",
      "gitignores" => "",
      "issue_labels" => "",
      "license" => "",
      "name" => "",
      "object_format_name" => "sha1",
      "private" => false,
      "readme" => "",
      "template" => false,
      "trust_model" => "default",
    }
  end
end
