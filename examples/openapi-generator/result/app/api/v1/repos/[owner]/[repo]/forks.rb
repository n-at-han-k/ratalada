# frozen_string_literal: true
# /repos/{owner}/{repo}/forks -- scaffolded from the document.

# Fork a repository
post "/" do
  content_type(:json)
  records = relations[:repository]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(202)
  record.to_h.to_json
end

# List a repository's forks
get "/" do
  content_type(:json)
  status(200)
  relations[:repository].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/forks", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/forks" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repository's forks" do
      tags "repository"
      operationId "listForks"
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

    post "Fork a repository" do
      tags "repository"
      operationId "createFork"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateForkOption}},
      )
      response 202, "Repository" do
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

  it "GET /api/v1/repos/{owner}/{repo}/forks answers 200" do
    Factory[:repository]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/forks answers 202" do
    assert_api_response :post, 202, path_params: {owner: "owner", repo: "repo"}, body: {"name" => "", "organization" => ""}
  end
end
