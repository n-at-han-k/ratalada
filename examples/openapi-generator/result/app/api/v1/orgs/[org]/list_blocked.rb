# frozen_string_literal: true
# /orgs/{org}/list_blocked -- scaffolded from the document.

# List the organization's blocked users
get "/" do
  content_type(:json)
  status(200)
  relations[:blocked_user].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/list_blocked", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/list_blocked" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "List the organization's blocked users" do
      tags "organization"
      operationId "orgListBlockedUsers"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "BlockedUserList" do
        schema({
  "type" => "array",
  "items" => Schemas::BlockedUser,
})
      end
    end
  end

  it "GET /api/v1/orgs/{org}/list_blocked answers 200" do
    Factory[:blocked_user]
    assert_api_response :get, 200, path_params: {org: "org"}
  end
end
