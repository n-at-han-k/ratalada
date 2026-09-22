# frozen_string_literal: true
# /admin/quota/groups/{quotagroup} -- scaffolded from the document.

# Delete a quota group
delete "/" do
  records = relations[:quota_group].where(:quotagroup => params["quotagroup"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get information about the quota group
get "/" do
  content_type(:json)
  record = relations[:quota_group].where(:quotagroup => params["quotagroup"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/quota/groups/{quotagroup}", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/quota/groups/{quotagroup}" do
    parameter name: :quotagroup, in: :path, schema: {"type" => "string"}, required: true

    get "Get information about the quota group" do
      tags "admin"
      operationId "adminGetQuotaGroup"
      response 200, "QuotaGroup" do
        schema(Schemas::QuotaGroup)
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

    delete "Delete a quota group" do
      tags "admin"
      operationId "adminDeleteQuotaGroup"
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

  it "GET /api/v1/admin/quota/groups/{quotagroup} answers 200" do
    Factory[:quota_group, :quotagroup => "quotagroup"]
    assert_api_response :get, 200, path_params: {quotagroup: "quotagroup"}
  end

  it "DELETE /api/v1/admin/quota/groups/{quotagroup} answers 204" do
    Factory[:quota_group, :quotagroup => "quotagroup"]
    assert_api_response :delete, 204, path_params: {quotagroup: "quotagroup"}
  end
end
