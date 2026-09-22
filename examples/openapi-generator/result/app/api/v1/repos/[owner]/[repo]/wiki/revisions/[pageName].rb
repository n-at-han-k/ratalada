# frozen_string_literal: true
# /repos/{owner}/{repo}/wiki/revisions/{pageName} -- scaffolded from the document.

# Get revisions of a wiki page
get "/" do
  content_type(:json)
  record = relations[:wiki_commit_list].where(:pageName => params["pageName"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/wiki/revisions/{pageName}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/wiki/revisions/{pageName}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :pageName, in: :path, schema: {"type" => "string"}, required: true

    get "Get revisions of a wiki page" do
      tags "repository"
      operationId "repoGetWikiPageRevisions"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "WikiCommitList" do
        schema(Schemas::WikiCommitList)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/wiki/revisions/{pageName} answers 200" do
    Factory[:wiki_commit_list, :pageName => "pageName"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", pageName: "pageName"}
  end
end
