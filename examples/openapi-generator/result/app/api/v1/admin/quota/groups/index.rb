# frozen_string_literal: true
# /admin/quota/groups -- scaffolded from the document.

# Create a new quota group
post "/" do
  content_type(:json)
  records = relations[:quota_group]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List the available quota groups
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "name" => "",
      "rules" => [{"limit" => 0, "name" => "", "subjects" => [""]}],
    },
  ].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/quota/groups", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/quota/groups" do

    get "List the available quota groups" do
      tags "admin"
      operationId "adminListQuotaGroups"
      response 200, "QuotaGroupList" do
        schema(Schemas::QuotaGroupList)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    post "Create a new quota group" do
      tags "admin"
      operationId "adminCreateQuotaGroup"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::CreateQuotaGroupOptions}},
      )
      response 201, "QuotaGroup" do
        schema(Schemas::QuotaGroup)
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

  it "GET /api/v1/admin/quota/groups answers 200" do
    assert_api_response :get, 200
  end

  it "POST /api/v1/admin/quota/groups answers 201" do
    assert_api_response :post, 201, body: {
      "name" => "",
      "rules" => [{"limit" => 0, "name" => "", "subjects" => [""]}],
    }
  end
end
