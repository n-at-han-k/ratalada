# frozen_string_literal: true
# /orgs/{org}/members/{username} -- scaffolded from the document.

# Remove a member from an organization
delete "/" do
  # params: org, username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Check if a user is a member of an organization
get "/" do
  # params: org, username
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/members/{username}", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/members/{username}" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :username, in: :path, schema: {"type" => "string"}, required: true

    get "Check if a user is a member of an organization" do
      tags "organization"
      operationId "orgIsMember"
      response 204, "user is a member"
      response 303, "redirection to /orgs/{org}/public_members/{username}"
      response 404, "user is not a member"
    end

    delete "Remove a member from an organization" do
      tags "organization"
      operationId "orgDeleteMember"
      response 204, "member removed"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/members/{username} answers 204" do
    assert_api_response :get, 204, path_params: {org: "org", username: "username"}
  end

  it "DELETE /api/v1/orgs/{org}/members/{username} answers 204" do
    assert_api_response :delete, 204, path_params: {org: "org", username: "username"}
  end
end
