# frozen_string_literal: true
# /repos/{owner}/{repo}/releases/{id}/assets -- scaffolded from the document.

# Create a release attachment
post "/" do
  content_type(:json)
  records = relations[:attachment]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List release's attachments
get "/" do
  content_type(:json)
  status(200)
  relations[:attachment].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/releases/{id}/assets", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/releases/{id}/assets" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List release's attachments" do
      tags "repository"
      operationId "repoListReleaseAttachments"
      response 200, "AttachmentList" do
        schema({
  "type" => "array",
  "items" => Schemas::Attachment,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a release attachment" do
      tags "repository"
      operationId "repoCreateReleaseAttachment"
      parameter name: :name, in: :query, schema: {"type" => "string"}, required: false
      request_body(
        required: false,
        content: {"multipart/form-data" => {schema: {
  "type" => "object",
  "required" => [],
  "properties" => {
    "attachment" => {
      "type" => "string",
      "description" => "attachment to upload (this parameter is incompatible with `external_url`)",
      "format" => "binary",
    },
    "external_url" => {
      "type" => "string",
      "description" => "url to external asset (this parameter is incompatible with `attachment`)",
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
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 413, "QuotaExceeded"
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/releases/{id}/assets answers 200" do
    Factory[:attachment]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", id: 0}
  end

  it "POST /api/v1/repos/{owner}/{repo}/releases/{id}/assets answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", id: 0}, body: {"attachment" => "", "external_url" => ""}
  end
end
