# frozen_string_literal: true
# /user/starred/{owner}/{repo} -- scaffolded from the document.

# Whether the authenticated is starring the repo
get "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Unstar the given repo
delete "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Star the given repo
put "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/starred/{owner}/{repo}", type: :openapi do
  openapi_schema :public_api

  api_path "/user/starred/{owner}/{repo}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Whether the authenticated is starring the repo" do
      tags "user"
      operationId "userCurrentCheckStarring"
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

    put "Star the given repo" do
      tags "user"
      operationId "userCurrentPutStar"
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

    delete "Unstar the given repo" do
      tags "user"
      operationId "userCurrentDeleteStar"
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

  it "GET /api/v1/user/starred/{owner}/{repo} answers 204" do
    assert_api_response :get, 204, path_params: {owner: "owner", repo: "repo"}
  end

  it "PUT /api/v1/user/starred/{owner}/{repo} answers 204" do
    assert_api_response :put, 204, path_params: {owner: "owner", repo: "repo"}
  end

  it "DELETE /api/v1/user/starred/{owner}/{repo} answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo"}
  end
end
