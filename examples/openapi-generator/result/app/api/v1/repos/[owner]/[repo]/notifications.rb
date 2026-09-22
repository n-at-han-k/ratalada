# frozen_string_literal: true
# /repos/{owner}/{repo}/notifications -- scaffolded from the document.

# List users's notification threads on a specific repo
get "/" do
  content_type(:json)
  status(200)
  relations[:notification_thread].to_a.map(&:to_h).to_json
end

# Mark notification threads as read, pinned or unread on a specific repo
put "/" do
  content_type(:json)
  records = relations[:notification_thread]
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
RSpec.describe "/repos/{owner}/{repo}/notifications", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/notifications" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List users's notification threads on a specific repo" do
      tags "notification"
      operationId "notifyGetRepoList"
      parameter name: :all, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :"status-types", in: :query, schema: {"type" => "array", "items" => {"type" => "string"}}, required: false
      parameter name: :"subject-type", in: :query, schema: {
  "type" => "array",
  "items" => {
    "enum" => ["issue", "pull", "repository"],
    "type" => "string",
  },
}, required: false
      parameter name: :since, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :before, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "NotificationThreadList" do
        schema({
  "type" => "array",
  "items" => Schemas::NotificationThread,
})
      end
    end

    put "Mark notification threads as read, pinned or unread on a specific repo" do
      tags "notification"
      operationId "notifyReadRepoList"
      parameter name: :all, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :"status-types", in: :query, schema: {"type" => "array", "items" => {"type" => "string"}}, required: false
      parameter name: :"to-status", in: :query, schema: {"type" => "string"}, required: false
      parameter name: :last_read_at, in: :query, schema: {"type" => "string", "format" => "date-time"}, required: false
      response 205, "NotificationThreadListWithoutPagination - Notification threads without pagination headers" do
        schema({
  "type" => "array",
  "items" => Schemas::NotificationThread,
})
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/notifications answers 200" do
    Factory[:notification_thread]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/notifications answers 205" do
    Factory[:notification_thread]
    assert_api_response :put, 205, path_params: {owner: "owner", repo: "repo"}
  end
end
