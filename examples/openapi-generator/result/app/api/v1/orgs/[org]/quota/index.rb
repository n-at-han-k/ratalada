# frozen_string_literal: true
# /orgs/{org}/quota -- scaffolded from the document.

# Get quota information for an organization
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
RSpec.describe "/orgs/{org}/quota", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/quota" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "Get quota information for an organization" do
      tags "organization"
      operationId "orgGetQuota"
      response 200, "QuotaInfo" do
        schema(Schemas::QuotaInfo)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/quota answers 200" do
    Factory[:quota_info]
    assert_api_response :get, 200, path_params: {org: "org"}
  end
end
