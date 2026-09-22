# frozen_string_literal: true
# /orgs/{org}/activities/feeds -- scaffolded from the document.

# List an organization's activity feeds
get "/" do
  content_type(:json)
  status(200)
  relations[:activity].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/activities/feeds", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/activities/feeds" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "List an organization's activity feeds" do
      tags "organization"
      operationId "orgListActivityFeeds"
      parameter name: :date, in: :query, schema: {"type" => "string", "format" => "date"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "ActivityFeedsList" do
        schema({
  "type" => "array",
  "items" => Schemas::Activity,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/activities/feeds answers 200" do
    Factory[:activity]
    assert_api_response :get, 200, path_params: {org: "org"}
  end
end
