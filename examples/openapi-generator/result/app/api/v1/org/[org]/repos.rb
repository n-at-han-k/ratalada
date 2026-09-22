# frozen_string_literal: true
# /org/{org}/repos -- scaffolded from the document.

# Create a repository in an organization
post "/" do
  content_type(:json)
  records = relations[:repository]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/org/{org}/repos", type: :openapi do
  openapi_schema :public_api

  api_path "/org/{org}/repos" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    post "Create a repository in an organization" do
      tags "organization"
      operationId "createOrgRepoDeprecated"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateRepoOption}},
      )
      response 201, "Repository" do
        schema(Schemas::Repository)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/org/{org}/repos answers 201" do
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
