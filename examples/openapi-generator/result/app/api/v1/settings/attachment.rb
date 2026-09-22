# frozen_string_literal: true
# /settings/attachment -- scaffolded from the document.

# Get instance's global settings for Attachment
get "/" do
  content_type(:json)
  record = relations[:general_attachment_settings].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/settings/attachment", type: :openapi do
  openapi_schema :public_api

  api_path "/settings/attachment" do

    get "Get instance's global settings for Attachment" do
      tags "settings"
      operationId "getGeneralAttachmentSettings"
      response 200, "GeneralAttachmentSettings" do
        schema(Schemas::GeneralAttachmentSettings)
      end
    end
  end

  it "GET /api/v1/settings/attachment answers 200" do
    Factory[:general_attachment_setting]
    assert_api_response :get, 200
  end
end
