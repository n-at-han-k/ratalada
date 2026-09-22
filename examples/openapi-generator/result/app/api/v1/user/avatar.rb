# frozen_string_literal: true
# /user/avatar -- scaffolded from the document.

# Delete avatar of the current user. It will be replaced by a default one
delete "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Update avatar of the current user
post "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/avatar", type: :openapi do
  openapi_schema :public_api

  api_path "/user/avatar" do

    post "Update avatar of the current user" do
      tags "user"
      operationId "userUpdateAvatar"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::UpdateUserAvatarOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    delete "Delete avatar of the current user. It will be replaced by a default one" do
      tags "user"
      operationId "userDeleteAvatar"
      response 204, "APIEmpty is an empty response"
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "POST /api/v1/user/avatar answers 204" do
    assert_api_response :post, 204, body: {"image" => ""}
  end

  it "DELETE /api/v1/user/avatar answers 204" do
    assert_api_response :delete, 204
  end
end
