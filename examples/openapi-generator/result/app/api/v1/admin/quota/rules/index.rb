# frozen_string_literal: true
# /admin/quota/rules -- scaffolded from the document.

# Create a new quota rule
post "/" do
  content_type(:json)
  records = relations[:quota_rule_info]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List the available quota rules
get "/" do
  content_type(:json)
  status(200)
  relations[:quota_rule_info].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/quota/rules", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/quota/rules" do

    get "List the available quota rules" do
      tags "admin"
      operationId "adminListQuotaRules"
      response 200, "QuotaRuleInfoList" do
        schema({
  "type" => "array",
  "items" => Schemas::QuotaRuleInfo,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    post "Create a new quota rule" do
      tags "admin"
      operationId "adminCreateQuotaRule"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::CreateQuotaRuleOptions}},
      )
      response 201, "QuotaRuleInfo" do
        schema(Schemas::QuotaRuleInfo)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 409, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/admin/quota/rules answers 200" do
    Factory[:quota_rule_info]
    assert_api_response :get, 200
  end

  it "POST /api/v1/admin/quota/rules answers 201" do
    assert_api_response :post, 201, body: {"limit" => 0, "name" => "", "subjects" => [""]}
  end
end
