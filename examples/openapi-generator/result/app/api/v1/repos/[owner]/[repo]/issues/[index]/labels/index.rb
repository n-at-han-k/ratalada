# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/labels -- scaffolded from the document.

# Add a label to an issue
post "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "color" => "",
      "description" => "",
      "exclusive" => false,
      "id" => 0,
      "is_archived" => false,
      "name" => "",
      "url" => "",
    },
  ].to_json
end

# Remove all labels from an issue
delete "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Get an issue's labels
get "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "color" => "",
      "description" => "",
      "exclusive" => false,
      "id" => 0,
      "is_archived" => false,
      "name" => "",
      "url" => "",
    },
  ].to_json
end

# Replace an issue's labels
put "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "color" => "",
      "description" => "",
      "exclusive" => false,
      "id" => 0,
      "is_archived" => false,
      "name" => "",
      "url" => "",
    },
  ].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/labels", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/labels" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get an issue's labels" do
      tags "issue"
      operationId "issueGetLabels"
      response 200, "LabelListWithoutPagination - Labels for a specific issue (no pagination headers)" do
        schema({
  "type" => "array",
  "items" => Schemas::Label,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Replace an issue's labels" do
      tags "issue"
      operationId "issueReplaceLabels"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::IssueLabelsOption}},
      )
      response 200, "LabelListWithoutPagination - Labels for a specific issue (no pagination headers)" do
        schema({
  "type" => "array",
  "items" => Schemas::Label,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Add a label to an issue" do
      tags "issue"
      operationId "issueAddLabel"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::IssueLabelsOption}},
      )
      response 200, "LabelListWithoutPagination - Labels for a specific issue (no pagination headers)" do
        schema({
  "type" => "array",
  "items" => Schemas::Label,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Remove all labels from an issue" do
      tags "issue"
      operationId "issueClearLabels"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::DeleteLabelsOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index}/labels answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/issues/{index}/labels answers 200" do
    assert_api_response :put, 200, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"labels" => [{}], "updated_at" => "2026-01-01T00:00:00Z"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues/{index}/labels answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"labels" => [{}], "updated_at" => "2026-01-01T00:00:00Z"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/labels answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"updated_at" => "2026-01-01T00:00:00Z"}
  end
end
