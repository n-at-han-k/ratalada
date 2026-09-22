# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls -- scaffolded from the document.

# Create a pull request
post "/" do
  content_type(:json)
  records = relations[:pull_request]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List a repo's pull requests. If a pull request is selected but fails to be retrieved for any reason, it will be a null value in the list of results.
get "/" do
  content_type(:json)
  status(200)
  relations[:pull_request].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repo's pull requests. If a pull request is selected but fails to be retrieved for any reason, it will be a null value in the list of results." do
      tags "repository"
      operationId "repoListPullRequests"
      parameter name: :state, in: :query, schema: {"type" => "string", "enum" => ["open", "closed", "all"]}, required: false
      parameter name: :sort, in: :query, schema: {
  "type" => "string",
  "enum" => [
    "oldest",
    "recentupdate",
    "recentclose",
    "leastupdate",
    "mostcomment",
    "leastcomment",
    "priority",
  ],
}, required: false
      parameter name: :milestone, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :labels, in: :query, schema: {
  "type" => "array",
  "items" => {"type" => "integer", "format" => "int64"},
}, required: false
      parameter name: :poster, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :base, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :head, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "PullRequestList" do
        schema({
  "type" => "array",
  "items" => Schemas::PullRequest,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 500, "APIError is error format response" do
        schema(Schemas::APIError)
      end
    end

    post "Create a pull request" do
      tags "repository"
      operationId "repoCreatePullRequest"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreatePullRequestOption}},
      )
      response 201, "PullRequest" do
        schema(Schemas::PullRequest)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 413, "QuotaExceeded"
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/pulls answers 200" do
    Factory[:pull_request]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/pulls answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
      "assignee" => "",
      "assignees" => [""],
      "base" => "",
      "body" => "",
      "due_date" => "2026-01-01T00:00:00Z",
      "head" => "",
      "labels" => [0],
      "milestone" => 0,
      "title" => "",
    }
  end
end
