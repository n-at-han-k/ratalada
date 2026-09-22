# frozen_string_literal: true
# /topics/search -- scaffolded from the document.

# Search for topics by keyword
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {
    "topics" => [
      {
        "created" => "2026-01-01T00:00:00Z",
        "id" => 0,
        "repo_count" => 0,
        "topic_name" => "",
        "updated" => "2026-01-01T00:00:00Z",
      },
    ],
  }.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/topics/search", type: :openapi do
  openapi_schema :public_api

  api_path "/topics/search" do

    get "Search for topics by keyword" do
      tags "repository"
      operationId "topicSearch"
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: true
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "SearchResults of a successful search" do
        schema({
  "type" => "object",
  "title" => "TopicSearchResults",
  "properties" => {
    "topics" => {
      "type" => "array",
      "items" => Schemas::TopicResponse,
    },
  },
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/topics/search answers 200" do
    assert_api_response :get, 200, params: {q: ""}
  end
end
