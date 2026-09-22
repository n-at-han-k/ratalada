# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/assets/{attachment_id} -- scaffolded from the document.

# Delete an issue attachment
delete "/" do
  records = relations[:attachment].where(:attachment_id => params["attachment_id"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Edit an issue attachment
patch "/" do
  content_type(:json)
  records = relations[:attachment].where(:attachment_id => params["attachment_id"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(201)
  record.to_h.to_json
end

# Get an issue attachment
get "/" do
  content_type(:json)
  record = relations[:attachment].where(:attachment_id => params["attachment_id"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/assets/{attachment_id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/assets/{attachment_id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :attachment_id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get an issue attachment" do
      tags "issue"
      operationId "issueGetIssueAttachment"
      response 200, "Attachment" do
        schema(Schemas::Attachment)
      end
      response 404, "APIError is error format response" do
        schema(Schemas::APIError)
      end
    end

    delete "Delete an issue attachment" do
      tags "issue"
      operationId "issueDeleteIssueAttachment"
      response 204, "APIEmpty is an empty response"
      response 404, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end

    patch "Edit an issue attachment" do
      tags "issue"
      operationId "issueEditIssueAttachment"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditAttachmentOptions}},
      )
      response 201, "Attachment" do
        schema(Schemas::Attachment)
      end
      response 404, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 413, "QuotaExceeded"
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index}/assets/{attachment_id} answers 200" do
    Factory[:attachment, :attachment_id => 0]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0, attachment_id: 0}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/assets/{attachment_id} answers 204" do
    Factory[:attachment, :attachment_id => 0]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0, attachment_id: 0}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/issues/{index}/assets/{attachment_id} answers 201" do
    Factory[:attachment, :attachment_id => 0]
    assert_api_response :patch, 201, path_params: {owner: "owner", repo: "repo", index: 0, attachment_id: 0}, body: {"browser_download_url" => "", "name" => ""}
  end
end
