# frozen_string_literal: true
# /orgs/{org}/quota/packages -- scaffolded from the document.

# List the packages affecting the organization's quota
get "/" do
  # params: org
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [
    {
      "html_url" => "",
      "name" => "",
      "size" => 0,
      "type" => "",
      "version" => "",
    },
  ].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/quota/packages", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/quota/packages" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "List the packages affecting the organization's quota" do
      tags "organization"
      operationId "orgListQuotaPackages"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "QuotaUsedPackageList" do
        schema(Schemas::QuotaUsedPackageList)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/quota/packages answers 200" do
    assert_api_response :get, 200, path_params: {org: "org"}
  end
end
