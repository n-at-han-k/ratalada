# frozen_string_literal: true
# /repos/{template_owner}/{template_repo}/generate -- scaffolded from the document.

# Create a repository using a template
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
RSpec.describe "/repos/{template_owner}/{template_repo}/generate", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{template_owner}/{template_repo}/generate" do
    parameter name: :template_owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :template_repo, in: :path, schema: {"type" => "string"}, required: true

    post "Create a repository using a template" do
      tags "repository"
      operationId "generateRepo"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::GenerateRepoOption}},
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
      response 409, "The repository with the same name already exists."
      response 413, "QuotaExceeded"
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/repos/{template_owner}/{template_repo}/generate answers 201" do
    assert_api_response :post, 201, path_params: {
      :template_owner => "template_owner",
      :template_repo => "template_repo",
    }, body: {
      "avatar" => false,
      "default_branch" => "",
      "description" => "",
      "git_content" => false,
      "git_hooks" => false,
      "labels" => false,
      "name" => "",
      "owner" => "",
      "private" => false,
      "protected_branch" => false,
      "topics" => false,
      "webhooks" => false,
    }
  end
end
