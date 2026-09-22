# frozen_string_literal: true
# /user/actions/runners/registration-token -- scaffolded from the document.

# Get the user's runner registration token
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
RSpec.describe "/user/actions/runners/registration-token", type: :openapi do
  openapi_schema :public_api

  api_path "/user/actions/runners/registration-token" do

    get "Get the user's runner registration token" do
      tags "user"
      operationId "userGetRunnerRegistrationToken"
      response 200, "RegistrationToken is a string used to register a runner with a server" do
        schema(Schemas::RegistrationToken)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/user/actions/runners/registration-token answers 200" do
    Factory[:registration_token]
    assert_api_response :get, 200
  end
end
