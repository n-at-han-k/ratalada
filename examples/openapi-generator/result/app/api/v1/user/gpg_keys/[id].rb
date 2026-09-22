# frozen_string_literal: true
# /user/gpg_keys/{id} -- scaffolded from the document.

# Remove a GPG public key from current user's account
delete "/" do
  records = relations[:gpg_key].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get a GPG key
get "/" do
  content_type(:json)
  record = relations[:gpg_key].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/gpg_keys/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/user/gpg_keys/{id}" do
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a GPG key" do
      tags "user"
      operationId "userCurrentGetGPGKey"
      response 200, "GPGKey" do
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
    end

    delete "Remove a GPG public key from current user's account" do
      tags "user"
      operationId "userCurrentDeleteGPGKey"
      response 204, "APIEmpty is an empty response"
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

  it "GET /api/v1/user/gpg_keys/{id} answers 200" do
    Factory[:gpg_key, :id => 1]
    assert_api_response :get, 200, path_params: {id: 1}
  end

  it "DELETE /api/v1/user/gpg_keys/{id} answers 204" do
    Factory[:gpg_key, :id => 1]
    assert_api_response :delete, 204, path_params: {id: 1}
  end
end
