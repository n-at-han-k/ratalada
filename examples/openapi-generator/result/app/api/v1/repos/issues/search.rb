# frozen_string_literal: true
# /repos/issues/search -- scaffolded from the document.

# Search for issues across the repositories that the user has access to
get "/" do
  content_type(:json)
  status(200)
  relations[:issue].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/issues/search", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/issues/search" do

    get "Search for issues across the repositories that the user has access to" do
      tags "issue"
      operationId "issueSearchIssues"
      parameter name: :state, in: :query, schema: {"type" => "string", "enum" => ["open", "closed", "all"]}, required: false
      parameter name: :labels, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :milestones, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :priority_repo_id, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :type, in: :query, schema: {"type" => "string", "enum" => ["issues", "pulls"]}, required: false
      parameter name: :since, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :before, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :assigned, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :created, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :mentioned, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :review_requested, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :reviewed, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :owner, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :team, in: :query, schema: {"type" => "string"}, required: false
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
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/issues/search answers 200" do
    Factory[:issue]
    assert_api_response :get, 200
  end
end
