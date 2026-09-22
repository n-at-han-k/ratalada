# frozen_string_literal: true
# /repos/{owner}/{repo}/languages -- scaffolded from the document.

# Get languages and number of bytes of code written
get "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/languages", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/languages" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get languages and number of bytes of code written" do
      tags "repository"
      operationId "repoGetLanguages"
      response 200, "LanguageStatistics" do
        schema({
  "type" => "object",
  "additionalProperties" => {"type" => "integer", "format" => "int64"},
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/languages answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
