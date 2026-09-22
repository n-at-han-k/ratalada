# frozen_string_literal: true
# /user/quota/artifacts -- scaffolded from the document.

# List the artifacts affecting the authenticated user's quota
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [{"html_url" => "", "name" => "", "size" => 0}].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/quota/artifacts", type: :openapi do
  openapi_schema :public_api

  api_path "/user/quota/artifacts" do

    get "List the artifacts affecting the authenticated user's quota" do
      tags "user"
      operationId "userListQuotaArtifacts"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "QuotaUsedArtifactList" do
        schema(Schemas::QuotaUsedArtifactList)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/user/quota/artifacts answers 200" do
    assert_api_response :get, 200
  end
end
