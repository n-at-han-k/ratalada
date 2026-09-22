# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index}/files -- scaffolded from the document.

# Get changed files for a pull request
get "/" do
  content_type(:json)
  status(200)
  relations[:changed_file].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}/files", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}/files" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get changed files for a pull request" do
      tags "repository"
      operationId "repoGetPullRequestFiles"
      parameter name: :"skip-to", in: :query, schema: {"type" => "string"}, required: false
      parameter name: :whitespace, in: :query, schema: {
  "type" => "string",
  "enum" => ["ignore-all", "ignore-change", "ignore-eol", "show-all"],
}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "ChangedFileListWithPagination" do
        schema({
  "type" => "array",
  "items" => Schemas::ChangedFile,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/pulls/{index}/files answers 200" do
    Factory[:changed_file]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
