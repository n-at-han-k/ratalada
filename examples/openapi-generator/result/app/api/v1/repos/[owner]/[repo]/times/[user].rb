# frozen_string_literal: true
# /repos/{owner}/{repo}/times/{user} -- scaffolded from the document.

# List a user's tracked times in a repo
get "/" do
  content_type(:json)
  status(200)
  relations[:tracked_time].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/times/{user}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/times/{user}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :user, in: :path, schema: {"type" => "string"}, required: true

    get "List a user's tracked times in a repo" do
      tags "repository"
      operationId "userTrackedTimes"
      response 200, "TrackedTimeListWithoutPagination - Tracked times for a specific user (no pagination headers)" do
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
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/times/{user} answers 200" do
    Factory[:tracked_time]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", user: "user"}
  end
end
