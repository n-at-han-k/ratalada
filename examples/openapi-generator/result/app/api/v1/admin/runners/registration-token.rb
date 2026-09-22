# frozen_string_literal: true
# /admin/runners/registration-token -- scaffolded from the document.

# Get a runner registration token for registering global runners
get "/" do
  content_type(:json)
  record = relations[:registration_token].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/runners/registration-token", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/runners/registration-token" do

    get "Get a runner registration token for registering global runners" do
      tags "admin"
      operationId "adminGetRegistrationToken"
      response 200, "RegistrationToken is a string used to register a runner with a server" do
        schema(Schemas::RegistrationToken)
      end
    end
  end

  it "GET /api/v1/admin/runners/registration-token answers 200" do
    Factory[:registration_token]
    assert_api_response :get, 200
  end
end
