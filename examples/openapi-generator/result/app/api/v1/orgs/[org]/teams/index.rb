# frozen_string_literal: true
# /orgs/{org}/teams -- scaffolded from the document.

# Create a team
post "/" do
  content_type(:json)
  records = relations[:team]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List an organization's teams
get "/" do
  content_type(:json)
  status(200)
  relations[:team].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/teams", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/teams" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "List an organization's teams" do
      tags "organization"
      operationId "orgListTeams"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "TeamList" do
        schema({
  "type" => "array",
  "items" => Schemas::Team,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a team" do
      tags "organization"
      operationId "orgCreateTeam"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateTeamOption}},
      )
      response 201, "Team" do
        schema(Schemas::Team)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/teams answers 200" do
    Factory[:team]
    assert_api_response :get, 200, path_params: {org: "org"}
  end

  it "POST /api/v1/orgs/{org}/teams answers 201" do
    assert_api_response :post, 201, path_params: {org: "org"}, body: {
      "can_create_org_repo" => false,
      "description" => "",
      "includes_all_repositories" => false,
      "name" => "",
      "permission" => "read",
      "units" => [""],
      "units_map" => {},
    }
  end
end
