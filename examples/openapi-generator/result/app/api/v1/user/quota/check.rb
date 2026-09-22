# frozen_string_literal: true
# /user/quota/check -- scaffolded from the document.

# Check if the authenticated user is over quota for a given subject
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  false.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/quota/check", type: :openapi do
  openapi_schema :public_api

  api_path "/user/quota/check" do

    get "Check if the authenticated user is over quota for a given subject" do
      tags "user"
      operationId "userCheckQuota"
      parameter name: :subject, in: :query, schema: {"type" => "string"}, required: true
      response 200, "Returns true if the action is accepted." do
        schema({"type" => "boolean"})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/user/quota/check answers 200" do
    assert_api_response :get, 200, params: {subject: ""}
  end
end
