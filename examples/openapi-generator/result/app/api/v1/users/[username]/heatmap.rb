# frozen_string_literal: true
# /users/{username}/heatmap -- scaffolded from the document.

# Get a user's heatmap
get "/" do
  content_type(:json)
  status(200)
  relations[:user_heatmap_data].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/users/{username}/heatmap", type: :openapi do
  openapi_schema :public_api

  api_path "/users/{username}/heatmap" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "Get a user's heatmap" do
      tags "user"
      operationId "userGetHeatmapData"
      response 200, "UserHeatmapData" do
        schema({
  "type" => "array",
  "items" => Schemas::UserHeatmapData,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/users/{username}/heatmap answers 200" do
    Factory[:user_heatmap_datum]
    assert_api_response :get, 200, path_params: {username: "username"}
  end
end
