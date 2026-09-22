# frozen_string_literal: true
# /users/{username}/subscriptions -- scaffolded from the document.

# List the repositories watched by a user
get "/" do
  content_type(:json)
  status(200)
  relations[:repository].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/users/{username}/subscriptions", type: :openapi do
  openapi_schema :public_api

  api_path "/users/{username}/subscriptions" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "List the repositories watched by a user" do
      tags "user"
      operationId "userListSubscriptions"
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

  it "GET /api/v1/users/{username}/subscriptions answers 200" do
    Factory[:repository]
    assert_api_response :get, 200, path_params: {username: "username"}
  end
end
