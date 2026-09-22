# frozen_string_literal: true
# /user/repos -- scaffolded from the document.

# Create a repository
post "/" do
  content_type(:json)
  records = relations[:repository]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List the repos that the authenticated user owns
get "/" do
  content_type(:json)
  status(200)
  relations[:repository].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/repos", type: :openapi do
  openapi_schema :public_api

  api_path "/user/repos" do

    get "List the repos that the authenticated user owns" do
      tags "user"
      operationId "userCurrentListRepos"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :order_by, in: :query, schema: {
  "type" => "string",
  "enum" => [
    "name",
    "id",
    "newest",
    "oldest",
    "recentupdate",
    "leastupdate",
    "reversealphabetically",
    "alphabetically",
    "reversesize",
    "size",
    "reversegitsize",
    "gitsize",
    "reverselfssize",
    "lfssize",
    "moststars",
    "feweststars",
    "mostforks",
    "fewestforks",
  ],
}, required: false
      response 200, "RepositoryList" do
        schema({
  "type" => "array",
  "items" => Schemas::Repository,
})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    post "Create a repository" do
      tags "repository", "user"
      operationId "createCurrentUserRepo"
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
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
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

  it "GET /api/v1/user/repos answers 200" do
    Factory[:repository]
    assert_api_response :get, 200
  end

  it "POST /api/v1/user/repos answers 201" do
    assert_api_response :post, 201, body: {
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
