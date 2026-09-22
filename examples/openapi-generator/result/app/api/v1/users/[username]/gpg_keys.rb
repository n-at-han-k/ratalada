# frozen_string_literal: true
# /users/{username}/gpg_keys -- scaffolded from the document.

# List the given user's GPG keys
get "/" do
  content_type(:json)
  status(200)
  relations[:gpg_key].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/users/{username}/gpg_keys", type: :openapi do
  openapi_schema :public_api

  api_path "/users/{username}/gpg_keys" do
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "List the given user's GPG keys" do
      tags "user"
      operationId "userListGPGKeys"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "GPGKeyList" do
        schema({
  "type" => "array",
  "items" => Schemas::GPGKey,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/users/{username}/gpg_keys answers 200" do
    Factory[:gpg_key]
    assert_api_response :get, 200, path_params: {username: "username"}
  end
end
