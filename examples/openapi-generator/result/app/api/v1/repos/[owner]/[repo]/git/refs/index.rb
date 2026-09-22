# frozen_string_literal: true
# /repos/{owner}/{repo}/git/refs -- scaffolded from the document.

# Get specified ref or filtered repository's refs
get "/" do
  content_type(:json)
  status(200)
  relations[:reference].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/git/refs", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/git/refs" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get specified ref or filtered repository's refs" do
      tags "repository"
      operationId "repoListAllGitRefs"
      response 200, "ReferenceList" do
        schema({
  "type" => "array",
  "items" => Schemas::Reference,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/git/refs answers 200" do
    Factory[:reference]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
