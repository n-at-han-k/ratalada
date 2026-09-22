# frozen_string_literal: true
# /repos/{owner}/{repo}/wiki/new -- scaffolded from the document.

# Create a wiki page
post "/" do
  content_type(:json)
  records = relations[:wiki_page]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/wiki/new", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/wiki/new" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    post "Create a wiki page" do
      tags "repository"
      operationId "repoCreateWikiPage"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateWikiPageOptions}},
      )
      response 201, "WikiPage" do
        schema(Schemas::WikiPage)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 413, "QuotaExceeded"
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/wiki/new answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {"content_base64" => "", "message" => "", "title" => ""}
  end
end
