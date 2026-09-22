# frozen_string_literal: true
# /user/teams -- scaffolded from the document.

# List all the teams a user belongs to
get "/" do
  content_type(:json)
  status(200)
  relations[:team].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/teams", type: :openapi do
  openapi_schema :public_api

  api_path "/user/teams" do

    get "List all the teams a user belongs to" do
      tags "user"
      operationId "userListTeams"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "TeamList" do
        schema({
  "type" => "array",
  "items" => Schemas::Team,
})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/user/teams answers 200" do
    Factory[:team]
    assert_api_response :get, 200
  end
end
