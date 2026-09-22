# frozen_string_literal: true
# /admin/quota/rules/{quotarule} -- scaffolded from the document.

# Deletes a quota rule
delete "/" do
  records = relations[:quota_rule_info].where(:quotarule => params["quotarule"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Change an existing quota rule
patch "/" do
  content_type(:json)
  records = relations[:quota_rule_info].where(:quotarule => params["quotarule"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get information about a quota rule
get "/" do
  content_type(:json)
  record = relations[:quota_rule_info].where(:quotarule => params["quotarule"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/quota/rules/{quotarule}", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/quota/rules/{quotarule}" do
    parameter name: :quotarule, in: :path, schema: {"type" => "string"}, required: true

    get "Get information about a quota rule" do
      tags "admin"
      operationId "adminGetQuotaRule"
      response 200, "QuotaRuleInfo" do
        schema(Schemas::QuotaRuleInfo)
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

    delete "Deletes a quota rule" do
      tags "admin"
      operationId "adminDeleteQuotaRule"
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

    patch "Change an existing quota rule" do
      tags "admin"
      operationId "adminEditQuotaRule"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::EditQuotaRuleOptions}},
      )
      response 200, "QuotaRuleInfo" do
        schema(Schemas::QuotaRuleInfo)
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

  it "GET /api/v1/admin/quota/rules/{quotarule} answers 200" do
    Factory[:quota_rule_info, :quotarule => "quotarule"]
    assert_api_response :get, 200, path_params: {quotarule: "quotarule"}
  end

  it "DELETE /api/v1/admin/quota/rules/{quotarule} answers 204" do
    Factory[:quota_rule_info, :quotarule => "quotarule"]
    assert_api_response :delete, 204, path_params: {quotarule: "quotarule"}
  end

  it "PATCH /api/v1/admin/quota/rules/{quotarule} answers 200" do
    Factory[:quota_rule_info, :quotarule => "quotarule"]
    assert_api_response :patch, 200, path_params: {quotarule: "quotarule"}, body: {"limit" => 0, "subjects" => [""]}
  end
end
