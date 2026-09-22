# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/comments/{id}/assets -- scaffolded from the document.

# Create a comment attachment
post "/" do
  content_type(:json)
  records = relations[:attachment]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List comment's attachments
get "/" do
  content_type(:json)
  status(200)
  relations[:attachment].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/comments/{id}/assets", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/comments/{id}/assets" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List comment's attachments" do
      tags "issue"
      operationId "issueListIssueCommentAttachments"
      response 200, "AttachmentList" do
        schema({
  "type" => "array",
  "items" => Schemas::Attachment,
})
      end
      response 404, "APIError is error format response" do
        schema(Schemas::APIError)
      end
    end

    post "Create a comment attachment" do
      tags "issue"
      operationId "issueCreateIssueCommentAttachment"
      parameter name: :name, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :updated_at, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      request_body(
        required: true,
        content: {"multipart/form-data" => {schema: {
  "type" => "object",
  "required" => ["attachment"],
  "properties" => {
    "attachment" => {
      "type" => "string",
      "description" => "attachment to upload",
      "format" => "binary",
    },
  },
}}},
      )
      response 201, "Attachment" do
        schema(Schemas::Attachment)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APIError is error format response" do
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

  it "GET /api/v1/repos/{owner}/{repo}/issues/comments/{id}/assets answers 200" do
    Factory[:attachment]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", id: 0}
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues/comments/{id}/assets answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", id: 0}, body: {"attachment" => ""}
  end
end
