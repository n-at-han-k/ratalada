# frozen_string_literal: true
# /repos/{owner}/{repo}/wiki/page/{pageName} -- scaffolded from the document.

# Delete a wiki page
delete "/" do
  records = relations[:wiki_page].where(:pageName => params["pageName"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Edit a wiki page
patch "/" do
  content_type(:json)
  records = relations[:wiki_page].where(:pageName => params["pageName"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get a wiki page
get "/" do
  content_type(:json)
  record = relations[:wiki_page].where(:pageName => params["pageName"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/wiki/page/{pageName}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/wiki/page/{pageName}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :pageName, in: :path, schema: {"type" => "string"}, required: true

    get "Get a wiki page" do
      tags "repository"
      operationId "repoGetWikiPage"
      response 200, "WikiPage" do
        schema(Schemas::WikiPage)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a wiki page" do
      tags "repository"
      operationId "repoDeleteWikiPage"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end

    patch "Edit a wiki page" do
      tags "repository"
      operationId "repoEditWikiPage"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateWikiPageOptions}},
      )
      response 200, "WikiPage" do
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

  it "GET /api/v1/repos/{owner}/{repo}/wiki/page/{pageName} answers 200" do
    Factory[:wiki_page, :pageName => "pageName"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", pageName: "pageName"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/wiki/page/{pageName} answers 204" do
    Factory[:wiki_page, :pageName => "pageName"]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", pageName: "pageName"}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/wiki/page/{pageName} answers 200" do
    Factory[:wiki_page, :pageName => "pageName"]
    assert_api_response :patch, 200, path_params: {owner: "owner", repo: "repo", pageName: "pageName"}, body: {"content_base64" => "", "message" => "", "title" => ""}
  end
end
