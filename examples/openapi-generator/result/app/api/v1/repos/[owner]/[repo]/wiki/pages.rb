# frozen_string_literal: true
# /repos/{owner}/{repo}/wiki/pages -- scaffolded from the document.

# Get all wiki pages
get "/" do
  content_type(:json)
  status(200)
  relations[:wiki_page_meta_data].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/wiki/pages", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/wiki/pages" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get all wiki pages" do
      tags "repository"
      operationId "repoGetWikiPages"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "WikiPageList" do
        schema({
  "type" => "array",
  "items" => Schemas::WikiPageMetaData,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/wiki/pages answers 200" do
    Factory[:wiki_page_meta_datum]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
