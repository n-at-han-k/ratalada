# frozen_string_literal: true
# /user/activitypub/follow -- scaffolded from the document.

# Follow a remote activitypub account
post "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/activitypub/follow", type: :openapi do
  openapi_schema :public_api

  api_path "/user/activitypub/follow" do

    post "Follow a remote activitypub account" do
      tags "user"
      operationId "userCurrentActivityPubFollow"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::APRemoteFollowOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/user/activitypub/follow answers 204" do
    assert_api_response :post, 204, body: {"target" => ""}
  end
end
