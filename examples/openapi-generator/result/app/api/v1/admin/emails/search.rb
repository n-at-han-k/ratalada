# frozen_string_literal: true
# /admin/emails/search -- scaffolded from the document.

# Search users' email addresses
get "/" do
  content_type(:json)
  status(200)
  relations[:email].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/emails/search", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/emails/search" do

    get "Search users' email addresses" do
      tags "admin"
      operationId "adminSearchEmails"
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "EmailList" do
        schema({
  "type" => "array",
  "items" => Schemas::Email,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/admin/emails/search answers 200" do
    Factory[:email]
    assert_api_response :get, 200
  end
end
