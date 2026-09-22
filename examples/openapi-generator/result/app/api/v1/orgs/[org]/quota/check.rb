# frozen_string_literal: true
# /orgs/{org}/quota/check -- scaffolded from the document.

# Check if the organization is over quota for a given subject
get "/" do
  # params: org
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  false.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/quota/check", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/quota/check" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "Check if the organization is over quota for a given subject" do
      tags "organization"
      operationId "orgCheckQuota"
      parameter name: :subject, in: :query, schema: {"type" => "string"}, required: true
      response 200, "Returns true if the action is accepted." do
        schema({"type" => "boolean"})
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

  it "GET /api/v1/orgs/{org}/quota/check answers 200" do
    assert_api_response :get, 200, path_params: {org: "org"}, params: {subject: ""}
  end
end
