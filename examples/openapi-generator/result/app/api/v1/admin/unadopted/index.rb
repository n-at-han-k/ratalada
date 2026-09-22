# frozen_string_literal: true
# /admin/unadopted -- scaffolded from the document.

# List unadopted repositories
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [""].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/unadopted", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/unadopted" do

    get "List unadopted repositories" do
      tags "admin"
      operationId "adminUnadoptedList"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :pattern, in: :query, schema: {"type" => "string"}, required: false
      response 200, "StringSlice" do
        schema({"type" => "array", "items" => {"type" => "string"}})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/admin/unadopted answers 200" do
    assert_api_response :get, 200
  end
end
