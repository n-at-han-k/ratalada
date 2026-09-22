# frozen_string_literal: true
# /user/times -- scaffolded from the document.

# List the current user's tracked times
get "/" do
  content_type(:json)
  status(200)
  relations[:tracked_time].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/times", type: :openapi do
  openapi_schema :public_api

  api_path "/user/times" do

    get "List the current user's tracked times" do
      tags "user"
      operationId "userCurrentTrackedTimes"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :since, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :before, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      response 200, "TrackedTimeList" do
        schema({
  "type" => "array",
  "items" => Schemas::TrackedTime,
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

  it "GET /api/v1/user/times answers 200" do
    Factory[:tracked_time]
    assert_api_response :get, 200
  end
end
