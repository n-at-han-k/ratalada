# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index} -- scaffolded from the document.

# Delete an issue
delete "/" do
  records = relations[:issue].where(:index => params["index"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Edit an issue. If using deadline only the date will be taken into account, and time of day ignored.
patch "/" do
  content_type(:json)
  records = relations[:issue].where(:index => params["index"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(201)
  record.to_h.to_json
end

# Get an issue
get "/" do
  content_type(:json)
  record = relations[:issue].where(:index => params["index"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get an issue" do
      tags "issue"
      operationId "issueGetIssue"
      response 200, "Issue" do
        schema(Schemas::Issue)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete an issue" do
      tags "issue"
      operationId "issueDelete"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Edit an issue. If using deadline only the date will be taken into account, and time of day ignored." do
      tags "issue"
      operationId "issueEditIssue"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditIssueOption}},
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
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index} answers 200" do
    Factory[:issue, :index => 0]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index} answers 204" do
    Factory[:issue, :index => 0]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/issues/{index} answers 201" do
    Factory[:issue, :index => 0]
    assert_api_response :patch, 201, path_params: {owner: "owner", repo: "repo", index: 0}, body: {
      "assignee" => "",
      "assignees" => [""],
      "body" => "",
      "due_date" => "2026-01-01T00:00:00Z",
      "milestone" => 0,
      "ref" => "",
      "state" => "",
      "title" => "",
      "unset_due_date" => false,
      "updated_at" => "2026-01-01T00:00:00Z",
    }
  end
end
