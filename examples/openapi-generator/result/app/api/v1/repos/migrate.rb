# frozen_string_literal: true
# /repos/migrate -- scaffolded from the document.

# Migrate a remote git repository
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
RSpec.describe "/repos/migrate", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/migrate" do

    post "Migrate a remote git repository" do
      tags "repository"
      operationId "repoMigrate"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::MigrateRepoOptions}},
      )
      response 201, "Repository" do
        schema(Schemas::Repository)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 409, "The repository with the same name already exists."
      response 413, "QuotaExceeded"
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/repos/migrate answers 201" do
    assert_api_response :post, 201, body: {
      "auth_password" => "",
      "auth_token" => "",
      "auth_username" => "",
      "clone_addr" => "",
      "description" => "",
      "issues" => false,
      "labels" => false,
      "lfs" => false,
      "lfs_endpoint" => "",
      "milestones" => false,
      "mirror" => false,
      "mirror_interval" => "",
      "private" => false,
      "pull_requests" => false,
      "releases" => false,
      "repo_name" => "",
      "repo_owner" => "",
      "service" => "git",
      "uid" => 0,
      "wiki" => false,
    }
  end
end
