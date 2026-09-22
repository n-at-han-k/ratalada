# frozen_string_literal: true
# /repos/{owner}/{repo}/times -- scaffolded from the document.

# List a repo's tracked times
get "/" do
  content_type(:json)
  status(200)
  relations[:tracked_time].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/times", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/times" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repo's tracked times" do
      tags "repository"
      operationId "repoTrackedTimes"
      parameter name: :user, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :since, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :before, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "TrackedTimeList" do
        schema({
  "type" => "array",
  "items" => Schemas::TrackedTime,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/times answers 200" do
    Factory[:tracked_time]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
