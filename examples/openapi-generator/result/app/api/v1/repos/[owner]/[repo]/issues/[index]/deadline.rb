# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/deadline -- scaffolded from the document.

# Set an issue deadline. If set to null, the deadline is deleted. If using deadline only the date will be taken into account, and time of day ignored.
post "/" do
  content_type(:json)
  records = relations[:issue_deadline]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/deadline", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/deadline" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Set an issue deadline. If set to null, the deadline is deleted. If using deadline only the date will be taken into account, and time of day ignored." do
      tags "issue"
      operationId "issueEditIssueDeadline"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditDeadlineOption}},
      )
      response 201, "IssueDeadline" do
        schema(Schemas::IssueDeadline)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues/{index}/deadline answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"due_date" => "2026-01-01T00:00:00Z"}
  end
end
