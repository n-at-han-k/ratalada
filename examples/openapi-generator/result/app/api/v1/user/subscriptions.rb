# frozen_string_literal: true
# /user/subscriptions -- scaffolded from the document.

# List repositories watched by the authenticated user
get "/" do
  content_type(:json)
  status(200)
  relations[:repository].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/subscriptions", type: :openapi do
  openapi_schema :public_api

  api_path "/user/subscriptions" do

    get "List repositories watched by the authenticated user" do
      tags "user"
      operationId "userCurrentListSubscriptions"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "RepositoryList" do
        schema({
  "type" => "array",
  "items" => Schemas::Repository,
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

  it "GET /api/v1/user/subscriptions answers 200" do
    Factory[:repository]
    assert_api_response :get, 200
  end
end
