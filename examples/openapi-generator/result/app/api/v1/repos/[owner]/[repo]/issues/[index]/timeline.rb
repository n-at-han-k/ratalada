# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/timeline -- scaffolded from the document.

# List all comments and events on an issue
get "/" do
  content_type(:json)
  status(200)
  relations[:timeline_comment].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/timeline", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/timeline" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List all comments and events on an issue" do
      tags "issue"
      operationId "issueGetCommentsAndTimeline"
      parameter name: :since, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :before, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      response 200, "TimelineList" do
        schema({
  "type" => "array",
  "items" => Schemas::TimelineComment,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
      response 500, "APIInternalServerError is an error that is raised when an internal server error occurs" do
        schema(Schemas::APIInternalServerError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index}/timeline answers 200" do
    Factory[:timeline_comment]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
