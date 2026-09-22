# frozen_string_literal: true
# /admin/users/{username}/quota -- scaffolded from the document.

# Get the user's quota info
get "/" do
  content_type(:json)
  record = relations[:quota_info].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/users/{username}/quota", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users/{username}/quota" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "Get the user's quota info" do
      tags "admin"
      operationId "adminGetUserQuota"
      response 200, "QuotaInfo" do
        schema(Schemas::QuotaInfo)
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

  it "GET /api/v1/admin/users/{username}/quota answers 200" do
    Factory[:quota_info]
    assert_api_response :get, 200, path_params: {username: "username"}
  end
end
