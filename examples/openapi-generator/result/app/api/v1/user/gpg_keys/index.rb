# frozen_string_literal: true
# /user/gpg_keys -- scaffolded from the document.

# List the authenticated user's GPG keys
get "/" do
  content_type(:json)
  status(200)
  relations[:gpg_key].to_a.map(&:to_h).to_json
end

# Add a GPG public key to current user's account
post "/" do
  content_type(:json)
  records = relations[:gpg_key]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/gpg_keys", type: :openapi do
  openapi_schema :public_api

  api_path "/user/gpg_keys" do

    get "List the authenticated user's GPG keys" do
      tags "user"
      operationId "userCurrentListGPGKeys"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "GPGKeyList" do
        schema({
  "type" => "array",
  "items" => Schemas::GPGKey,
})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    post "Add a GPG public key to current user's account" do
      tags "user"
      operationId "userCurrentPostGPGKey"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateGPGKeyOption}},
      )
      response 201, "GPGKey" do
        schema(Schemas::GPGKey)
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
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/user/gpg_keys answers 200" do
    Factory[:gpg_key]
    assert_api_response :get, 200
  end

  it "POST /api/v1/user/gpg_keys answers 201" do
    assert_api_response :post, 201, body: {"armored_public_key" => "", "armored_signature" => ""}
  end
end
