# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/subscriptions/check -- scaffolded from the document.

# Check if user is subscribed to an issue
get "/" do
  content_type(:json)
  record = relations[:watch_info].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/subscriptions/check", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/subscriptions/check" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Check if user is subscribed to an issue" do
      tags "issue"
      operationId "issueCheckSubscription"
      response 200, "WatchInfo" do
        schema(Schemas::WatchInfo)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index}/subscriptions/check answers 200" do
    Factory[:watch_info]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
