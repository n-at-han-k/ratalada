# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/pinned -- scaffolded from the document.

# List a repo's pinned issues
get "/" do
  content_type(:json)
  status(200)
  relations[:issue].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/pinned", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/pinned" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repo's pinned issues" do
      tags "repository"
      operationId "repoListPinnedIssues"
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
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/pinned answers 200" do
    Factory[:issue]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
