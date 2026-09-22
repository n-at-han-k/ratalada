# frozen_string_literal: true
# /teams/{id}/repos -- scaffolded from the document.

# List a team's repos
get "/" do
  content_type(:json)
  status(200)
  relations[:repository].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/teams/{id}/repos", type: :openapi do
  openapi_schema :public_api

  api_path "/teams/{id}/repos" do
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List a team's repos" do
      tags "organization"
      operationId "orgListTeamRepos"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "RepositoryList" do
        schema({
  "type" => "array",
  "items" => Schemas::Repository,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/teams/{id}/repos answers 200" do
    Factory[:repository]
    assert_api_response :get, 200, path_params: {id: 0}
  end
end
