# frozen_string_literal: true
# /user/quota -- scaffolded from the document.

# Get quota information for the authenticated user
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
RSpec.describe "/user/quota", type: :openapi do
  openapi_schema :public_api

  api_path "/user/quota" do

    get "Get quota information for the authenticated user" do
      tags "user"
      operationId "userGetQuota"
      response 200, "QuotaInfo" do
        schema(Schemas::QuotaInfo)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/user/quota answers 200" do
    Factory[:quota_info]
    assert_api_response :get, 200
  end
end
