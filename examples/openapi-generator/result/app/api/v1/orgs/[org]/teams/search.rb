# frozen_string_literal: true
# /orgs/{org}/teams/search -- scaffolded from the document.

# Search for teams within an organization
get "/" do
  # params: org
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {
    "data" => [
      {
        "can_create_org_repo" => false,
        "description" => "",
        "id" => 0,
        "includes_all_repositories" => false,
        "name" => "",
        "organization" => {
          "avatar_url" => "",
          "created" => "2026-01-01T00:00:00Z",
          "description" => "",
          "email" => "",
          "full_name" => "",
          "id" => 0,
          "location" => "",
          "name" => "",
          "repo_admin_change_team_access" => false,
          "username" => "",
          "visibility" => "",
          "website" => "",
        },
        "permission" => "none",
        "units" => [""],
        "units_map" => {},
      },
    ],
    "ok" => false,
  }.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/teams/search", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/teams/search" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "Search for teams within an organization" do
      tags "organization"
      operationId "teamSearch"
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :include_desc, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "SearchResults of a successful search" do
        schema({
  "type" => "object",
  "title" => "TeamSearchResults",
  "properties" => {
    "data" => {
      "type" => "array",
      "items" => Schemas::Team,
    },
    "ok" => {"type" => "boolean"},
  },
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/teams/search answers 200" do
    assert_api_response :get, 200, path_params: {org: "org"}
  end
end
