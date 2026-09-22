# frozen_string_literal: true
# /settings/api -- scaffolded from the document.

# Get instance's global settings for api
get "/" do
  content_type(:json)
  record = relations[:general_api_settings].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/settings/api", type: :openapi do
  openapi_schema :public_api

  api_path "/settings/api" do

    get "Get instance's global settings for api" do
      tags "settings"
      operationId "getGeneralAPISettings"
      response 200, "GeneralAPISettings" do
        schema(Schemas::GeneralAPISettings)
      end
    end
  end

  it "GET /api/v1/settings/api answers 200" do
    Factory[:general_api_setting]
    assert_api_response :get, 200
  end
end
