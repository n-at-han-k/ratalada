# frozen_string_literal: true
# /orgs/{org}/actions/runners/registration-token -- scaffolded from the document.

# Get the organization's runner registration token
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
RSpec.describe "/orgs/{org}/actions/runners/registration-token", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/actions/runners/registration-token" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "Get the organization's runner registration token" do
      tags "organization"
      operationId "orgGetRunnerRegistrationToken"
      response 200, "RegistrationToken is a string used to register a runner with a server" do
        schema(Schemas::RegistrationToken)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/actions/runners/registration-token answers 200" do
    Factory[:registration_token]
    assert_api_response :get, 200, path_params: {org: "org"}
  end
end
