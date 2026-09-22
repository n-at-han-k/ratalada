# frozen_string_literal: true
# /repos/{owner}/{repo}/statuses/{sha} -- scaffolded from the document.

# Create a commit status
post "/" do
  content_type(:json)
  records = relations[:commit_status]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# Get a commit's statuses
get "/" do
  content_type(:json)
  status(200)
  relations[:commit_status].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/statuses/{sha}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/statuses/{sha}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :sha, in: :path, schema: {"type" => "string"}, required: true

    get "Get a commit's statuses" do
      tags "repository"
      operationId "repoListStatuses"
      parameter name: :sort, in: :query, schema: {
  "type" => "string",
  "enum" => [
    "oldest",
    "recentupdate",
    "leastupdate",
    "leastindex",
    "highestindex",
  ],
}, required: false
      parameter name: :state, in: :query, schema: {
  "type" => "string",
  "enum" => ["pending", "success", "error", "failure", "warning"],
}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "CommitStatusList" do
        schema({
  "type" => "array",
  "items" => Schemas::CommitStatus,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a commit status" do
      tags "repository"
      operationId "repoCreateStatus"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateStatusOption}},
      )
      response 201, "CommitStatus" do
        schema(Schemas::CommitStatus)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/statuses/{sha} answers 200" do
    Factory[:commit_status]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", sha: "sha"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/statuses/{sha} answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", sha: "sha"}, body: {
      "context" => "",
      "description" => "",
      "state" => "",
      "target_url" => "",
    }
  end
end
