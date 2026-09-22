# frozen_string_literal: true
# /user/gpg_key_verify -- scaffolded from the document.

# Verify a GPG key
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
RSpec.describe "/user/gpg_key_verify", type: :openapi do
  openapi_schema :public_api

  api_path "/user/gpg_key_verify" do

    post "Verify a GPG key" do
      tags "user"
      operationId "userVerifyGPGKey"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::VerifyGPGKeyOption}},
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

  it "POST /api/v1/user/gpg_key_verify answers 201" do
    assert_api_response :post, 201, body: {"armored_signature" => "", "key_id" => ""}
  end
end
