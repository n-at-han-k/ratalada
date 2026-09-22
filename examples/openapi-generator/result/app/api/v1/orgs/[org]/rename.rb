# frozen_string_literal: true
# /orgs/{org}/rename -- scaffolded from the document.

# Rename an organization
post "/" do
  # params: org
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/rename", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/rename" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    post "Rename an organization" do
      tags "organization"
      operationId "renameOrg"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::RenameOrgOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/orgs/{org}/rename answers 204" do
    assert_api_response :post, 204, path_params: {org: "org"}, body: {"new_name" => ""}
  end
end
