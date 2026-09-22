# frozen_string_literal: true
# /signing-key.gpg -- scaffolded from the document.

# Get default signing-key.gpg
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  "".to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/signing-key.gpg", type: :openapi do
  openapi_schema :public_api

  api_path "/signing-key.gpg" do

    get "Get default signing-key.gpg" do
      tags "miscellaneous"
      operationId "getSigningKey"
      response 200, "GPG armored public key" do
        schema({"type" => "string"})
      end
    end
  end

  it "GET /api/v1/signing-key.gpg answers 200" do
    assert_api_response :get, 200
  end
end
