# frozen_string_literal: true
# /admin/users/{username}/keys -- scaffolded from the document.

# Add an SSH public key to user's account
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
RSpec.describe "/admin/users/{username}/keys", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/users/{username}/keys" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    post "Add an SSH public key to user's account" do
      tags "admin"
      operationId "adminCreatePublicKey"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateKeyOption}},
      )
      response 201, "PublicKey" do
        schema(Schemas::PublicKey)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/admin/users/{username}/keys answers 201" do
    assert_api_response :post, 201, path_params: {username: "username"}, body: {"key" => "", "read_only" => false, "title" => ""}
  end
end
