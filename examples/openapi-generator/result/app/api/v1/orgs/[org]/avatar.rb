# frozen_string_literal: true
# /orgs/{org}/avatar -- scaffolded from the document.

# Delete an organization's avatar. It will be replaced by a default one
delete "/" do
  # params: org
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Update an organization's avatar
post "/" do
  # params: org
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/avatar", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/avatar" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    post "Update an organization's avatar" do
      tags "organization"
      operationId "orgUpdateAvatar"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::UpdateUserAvatarOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete an organization's avatar. It will be replaced by a default one" do
      tags "organization"
      operationId "orgDeleteAvatar"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/orgs/{org}/avatar answers 204" do
    assert_api_response :post, 204, path_params: {org: "org"}, body: {"image" => ""}
  end

  it "DELETE /api/v1/orgs/{org}/avatar answers 204" do
    assert_api_response :delete, 204, path_params: {org: "org"}
  end
end
