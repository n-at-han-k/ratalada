# frozen_string_literal: true
# /user/quota/attachments -- scaffolded from the document.

# List the attachments affecting the authenticated user's quota
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "api_url" => "",
      "contained_in" => {"api_url" => "", "html_url" => ""},
      "name" => "",
      "size" => 0,
    },
  ].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/quota/attachments", type: :openapi do
  openapi_schema :public_api

  api_path "/user/quota/attachments" do

    get "List the attachments affecting the authenticated user's quota" do
      tags "user"
      operationId "userListQuotaAttachments"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "QuotaUsedAttachmentList" do
        schema(Schemas::QuotaUsedAttachmentList)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/user/quota/attachments answers 200" do
    assert_api_response :get, 200
  end
end
