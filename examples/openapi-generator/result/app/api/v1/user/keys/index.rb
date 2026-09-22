# frozen_string_literal: true
# /user/keys -- scaffolded from the document.

# List the authenticated user's public keys
get "/" do
  content_type(:json)
  status(200)
  relations[:public_key].to_a.map(&:to_h).to_json
end

# Create a public key
post "/" do
  content_type(:json)
  records = relations[:public_key]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/keys", type: :openapi do
  openapi_schema :public_api

  api_path "/user/keys" do

    get "List the authenticated user's public keys" do
      tags "user"
      operationId "userCurrentListKeys"
      parameter name: :fingerprint, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "PublicKeyList" do
        schema({
  "type" => "array",
  "items" => Schemas::PublicKey,
})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    post "Create a public key" do
      tags "user"
      operationId "userCurrentPostKey"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateKeyOption}},
      )
      response 201, "PublicKey" do
        schema(Schemas::PublicKey)
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

  it "GET /api/v1/user/keys answers 200" do
    Factory[:public_key]
    assert_api_response :get, 200
  end

  it "POST /api/v1/user/keys answers 201" do
    assert_api_response :post, 201, body: {"key" => "", "read_only" => false, "title" => ""}
  end
end
