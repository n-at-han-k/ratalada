# frozen_string_literal: true
# /user/stopwatches -- scaffolded from the document.

# Get list of all existing stopwatches
get "/" do
  content_type(:json)
  status(200)
  relations[:stop_watch].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/stopwatches", type: :openapi do
  openapi_schema :public_api

  api_path "/user/stopwatches" do

    get "Get list of all existing stopwatches" do
      tags "user"
      operationId "userGetStopWatches"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "StopWatchList" do
        schema({
  "type" => "array",
  "items" => Schemas::StopWatch,
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

  it "GET /api/v1/user/stopwatches answers 200" do
    Factory[:stop_watch]
    assert_api_response :get, 200
  end
end
