# frozen_string_literal: true
# /user/actions/variables -- scaffolded from the document.

# Get the user-level list of variables which is created by current doer
get "/" do
  content_type(:json)
  status(200)
  relations[:action_variable].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/actions/variables", type: :openapi do
  openapi_schema :public_api

  api_path "/user/actions/variables" do

    get "Get the user-level list of variables which is created by current doer" do
      tags "user"
      operationId "getUserVariablesList"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "VariableList" do
        schema({
  "type" => "array",
  "items" => Schemas::ActionVariable,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/user/actions/variables answers 200" do
    Factory[:action_variable]
    assert_api_response :get, 200
  end
end
