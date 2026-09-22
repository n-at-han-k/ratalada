# frozen_string_literal: true
# /repos/{owner}/{repo}/issues -- scaffolded from the document.

# Create an issue. If using deadline only the date will be taken into account, and time of day ignored.
post "/" do
  content_type(:json)
  records = relations[:issue]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List a repository's issues
get "/" do
  content_type(:json)
  status(200)
  relations[:issue].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repository's issues" do
      tags "issue"
      operationId "issueListIssues"
      parameter name: :state, in: :query, schema: {"type" => "string", "enum" => ["closed", "open", "all"]}, required: false
      parameter name: :labels, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :type, in: :query, schema: {"type" => "string", "enum" => ["issues", "pulls"]}, required: false
      parameter name: :milestones, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :since, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :before, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :created_by, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :assigned_by, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :mentioned_by, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :sort, in: :query, schema: {
  "type" => "string",
  "enum" => [
    "relevance",
    "latest",
    "oldest",
    "recentupdate",
    "leastupdate",
    "mostcomment",
    "leastcomment",
    "nearduedate",
    "farduedate",
  ],
}, required: false
      response 200, "IssueList" do
        schema({
  "type" => "array",
  "items" => Schemas::Issue,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    post "Create an issue. If using deadline only the date will be taken into account, and time of day ignored." do
      tags "issue"
      operationId "issueCreateIssue"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateIssueOption}},
      )
      response 201, "Issue" do
        schema(Schemas::Issue)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 412, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues answers 200" do
    Factory[:issue]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
      "assignee" => "",
      "assignees" => [""],
      "body" => "",
      "closed" => false,
      "due_date" => "2026-01-01T00:00:00Z",
      "labels" => [0],
      "milestone" => 0,
      "ref" => "",
      "title" => "",
    }
  end
end
