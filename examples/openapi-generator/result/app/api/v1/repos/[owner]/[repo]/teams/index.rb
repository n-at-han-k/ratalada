# frozen_string_literal: true
# /repos/{owner}/{repo}/teams -- scaffolded from the document.

# List a repository's teams
get "/" do
  content_type(:json)
  status(200)
  relations[:team].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/teams", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/teams" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repository's teams" do
      tags "repository"
      operationId "repoListTeams"
      response 200, "TeamListWithoutPagination - Teams without pagination headers" do
        schema({
  "type" => "array",
  "items" => Schemas::Team,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 405, "APIError is error format response" do
        schema(Schemas::APIError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/teams answers 200" do
    Factory[:team]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
