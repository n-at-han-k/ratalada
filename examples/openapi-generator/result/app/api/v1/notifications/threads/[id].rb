# frozen_string_literal: true
# /notifications/threads/{id} -- scaffolded from the document.

# Get notification thread by ID
get "/" do
  content_type(:json)
  record = relations[:notification_thread].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Mark notification thread as read by ID
patch "/" do
  content_type(:json)
  records = relations[:notification_thread].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(205)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/notifications/threads/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/notifications/threads/{id}" do
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get notification thread by ID" do
      tags "notification"
      operationId "notifyGetThread"
      response 200, "NotificationThread" do
        schema(Schemas::NotificationThread)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Mark notification thread as read by ID" do
      tags "notification"
      operationId "notifyReadThread"
      parameter name: :"to-status", in: :query, schema: {"type" => "string"}, required: false
      response 205, "NotificationThread" do
        schema(Schemas::NotificationThread)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/notifications/threads/{id} answers 200" do
    Factory[:notification_thread, :id => 1]
    assert_api_response :get, 200, path_params: {id: 1}
  end

  it "PATCH /api/v1/notifications/threads/{id} answers 205" do
    Factory[:notification_thread, :id => 1]
    assert_api_response :patch, 205, path_params: {id: 1}
  end
end
