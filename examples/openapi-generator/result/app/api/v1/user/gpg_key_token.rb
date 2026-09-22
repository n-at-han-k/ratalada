# frozen_string_literal: true
# /user/gpg_key_token -- scaffolded from the document.

# Get a Token to verify
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  "".to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/gpg_key_token", type: :openapi do
  openapi_schema :public_api

  api_path "/user/gpg_key_token" do

    get "Get a Token to verify" do
      tags "user"
      operationId "getVerificationToken"
      response 200, "APIString is a string response" do
        schema({"type" => "string"})
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

  it "GET /api/v1/user/gpg_key_token answers 200" do
    assert_api_response :get, 200
  end
end
