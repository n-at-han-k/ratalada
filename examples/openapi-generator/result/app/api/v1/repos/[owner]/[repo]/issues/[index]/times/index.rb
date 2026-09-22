# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/times -- scaffolded from the document.

# Add tracked time to a issue
post "/" do
  content_type(:json)
  records = relations[:tracked_time]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(200)
  record.to_h.to_json
end

# Reset a tracked time of an issue
delete "/" do
  records = relations[:tracked_time]
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# List an issue's tracked times
get "/" do
  content_type(:json)
  status(200)
  relations[:tracked_time].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/times", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/times" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List an issue's tracked times" do
      tags "issue"
      operationId "issueTrackedTimes"
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

    post "Add tracked time to a issue" do
      tags "issue"
      operationId "issueAddTime"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::AddTimeOption}},
      )
      response 200, "TrackedTime" do
        schema(Schemas::TrackedTime)
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

    delete "Reset a tracked time of an issue" do
      tags "issue"
      operationId "issueResetTime"
      response 204, "APIEmpty is an empty response"
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

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index}/times answers 200" do
    Factory[:tracked_time]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues/{index}/times answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", index: 0}, body: {
      "created" => "2026-01-01T00:00:00Z",
      "time" => 0,
      "user_name" => "",
    }
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/times answers 204" do
    Factory[:tracked_time]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
