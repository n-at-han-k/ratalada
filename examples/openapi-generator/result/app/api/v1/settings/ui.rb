# frozen_string_literal: true
# /settings/ui -- scaffolded from the document.

# Get instance's global settings for ui
get "/" do
  content_type(:json)
  record = relations[:general_ui_settings].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/settings/ui", type: :openapi do
  openapi_schema :public_api

  api_path "/settings/ui" do

    get "Get instance's global settings for ui" do
      tags "settings"
      operationId "getGeneralUISettings"
      response 200, "GeneralUISettings" do
        schema(Schemas::GeneralUISettings)
      end
    end
  end

  it "GET /api/v1/settings/ui answers 200" do
    Factory[:general_ui_setting]
    assert_api_response :get, 200
  end
end
