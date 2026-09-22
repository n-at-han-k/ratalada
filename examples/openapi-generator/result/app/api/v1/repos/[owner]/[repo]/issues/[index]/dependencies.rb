# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/dependencies -- scaffolded from the document.

# Make the issue in the url depend on the issue in the form.
post "/" do
  content_type(:json)
  records = relations[:issue]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List an issue's dependencies, i.e all issues that block this issue.
get "/" do
  content_type(:json)
  status(200)
  relations[:issue].to_a.map(&:to_h).to_json
end

# Remove an issue dependency
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
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/dependencies", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/dependencies" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List an issue's dependencies, i.e all issues that block this issue." do
      tags "issue"
      operationId "issueListIssueDependencies"
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

    post "Make the issue in the url depend on the issue in the form." do
      tags "issue"
      operationId "issueCreateIssueDependencies"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::IssueMeta}},
      )
      response 201, "Issue" do
        schema(Schemas::Issue)
      end
      response 404, "the issue does not exist"
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end

    delete "Remove an issue dependency" do
      tags "issue"
      operationId "issueRemoveIssueDependencies"
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
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index}/dependencies answers 200" do
    Factory[:issue]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues/{index}/dependencies answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"index" => 0, "owner" => "", "repo" => ""}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/dependencies answers 200" do
    Factory[:issue]
    assert_api_response :delete, 200, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"index" => 0, "owner" => "", "repo" => ""}
  end
end
