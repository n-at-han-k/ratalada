# frozen_string_literal: true
# /orgs/{org}/quota/attachments -- scaffolded from the document.

# List the attachments affecting the organization's quota
get "/" do
  # params: org
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
RSpec.describe "/orgs/{org}/quota/attachments", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/quota/attachments" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "List the attachments affecting the organization's quota" do
      tags "organization"
      operationId "orgListQuotaAttachments"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "QuotaUsedAttachmentList" do
        schema(Schemas::QuotaUsedAttachmentList)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/quota/attachments answers 200" do
    assert_api_response :get, 200, path_params: {org: "org"}
  end
end
