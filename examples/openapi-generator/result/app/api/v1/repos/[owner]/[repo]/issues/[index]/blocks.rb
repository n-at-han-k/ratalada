# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/blocks -- scaffolded from the document.

# Block the issue given in the body by the issue in path
post "/" do
  content_type(:json)
  records = relations[:issue]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List issues that are blocked by this issue
get "/" do
  content_type(:json)
  status(200)
  relations[:issue].to_a.map(&:to_h).to_json
end

# Unblock the issue given in the body by the issue in path
delete "/" do
  records = relations[:issue]
  not_found! if records.count.zero?
  records.command(:delete).call
  status(200)
  ""
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/blocks", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/blocks" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List issues that are blocked by this issue" do
      tags "issue"
      operationId "issueListBlocks"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "IssueListWithoutPagination - Issues without pagination headers (used for pinned issues, dependencies, etc.)" do
        schema({
  "type" => "array",
  "items" => Schemas::Issue,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Block the issue given in the body by the issue in path" do
      tags "issue"
      operationId "issueCreateIssueBlocking"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::IssueMeta}},
      )
      response 201, "Issue" do
        schema(Schemas::Issue)
      end
      response 404, "the issue does not exist"
    end

    delete "Unblock the issue given in the body by the issue in path" do
      tags "issue"
      operationId "issueRemoveIssueBlocking"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::IssueMeta}},
      )
      response 200, "Issue" do
        schema(Schemas::Issue)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index}/blocks answers 200" do
    Factory[:issue]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues/{index}/blocks answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"index" => 0, "owner" => "", "repo" => ""}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/blocks answers 200" do
    Factory[:issue]
    assert_api_response :delete, 200, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"index" => 0, "owner" => "", "repo" => ""}
  end
end
