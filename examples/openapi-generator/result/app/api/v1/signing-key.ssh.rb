# frozen_string_literal: true
# /signing-key.ssh -- scaffolded from the document.

# Get default signing-key.ssh
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  "".to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/signing-key.ssh", type: :openapi do
  openapi_schema :public_api

  api_path "/signing-key.ssh" do

    get "Get default signing-key.ssh" do
      tags "miscellaneous"
      operationId "getSSHSigningKey"
      response 200, "SSH public key in OpenSSH authorized key format" do
        schema({"type" => "string"})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/signing-key.ssh answers 200" do
    assert_api_response :get, 200
  end
end
