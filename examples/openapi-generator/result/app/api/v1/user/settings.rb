# frozen_string_literal: true
# /user/settings -- scaffolded from the document.

# Get current user's account settings
get "/" do
  content_type(:json)
  record = relations[:user_settings].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Update settings in current user's account
patch "/" do
  content_type(:json)
  records = relations[:user_settings]
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/settings", type: :openapi do
  openapi_schema :public_api

  api_path "/user/settings" do

    get "Get current user's account settings" do
      tags "user"
      operationId "getUserSettings"
      response 200, "UserSettings" do
        schema(Schemas::UserSettings)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    patch "Update settings in current user's account" do
      tags "user"
      operationId "updateUserSettings"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::UserSettingsOptions}},
      )
      response 200, "UserSettings" do
        schema(Schemas::UserSettings)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/user/settings answers 200" do
    Factory[:user_setting]
    assert_api_response :get, 200
  end

  it "PATCH /api/v1/user/settings answers 200" do
    Factory[:user_setting]
    assert_api_response :patch, 200, body: {
      "description" => "",
      "diff_view_style" => "",
      "enable_repo_unit_hints" => false,
      "full_name" => "",
      "hide_activity" => false,
      "hide_email" => false,
      "hide_pronouns" => false,
      "language" => "",
      "location" => "",
      "pronouns" => "",
      "theme" => "",
      "website" => "",
    }
  end
end
