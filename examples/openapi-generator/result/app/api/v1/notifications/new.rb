# frozen_string_literal: true
# /notifications/new -- scaffolded from the document.

# Check if unread notifications exist
get "/" do
  content_type(:json)
  record = relations[:notification_count].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/notifications/new", type: :openapi do
  openapi_schema :public_api

  api_path "/notifications/new" do

    get "Check if unread notifications exist" do
      tags "notification"
      operationId "notifyNewAvailable"
      response 200, "Number of unread notifications" do
        schema(Schemas::NotificationCount)
      end
    end
  end

  it "GET /api/v1/notifications/new answers 200" do
    Factory[:notification_count]
    assert_api_response :get, 200
  end
end
