# frozen_string_literal: true
# /user/list_blocked -- scaffolded from the document.

# List the authenticated user's blocked users
get "/" do
  content_type(:json)
  status(200)
  relations[:blocked_user].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/list_blocked", type: :openapi do
  openapi_schema :public_api

  api_path "/user/list_blocked" do

    get "List the authenticated user's blocked users" do
      tags "user"
      operationId "userListBlockedUsers"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "BlockedUserList" do
        schema({
  "type" => "array",
  "items" => Schemas::BlockedUser,
})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/user/list_blocked answers 200" do
    Factory[:blocked_user]
    assert_api_response :get, 200
  end
end
