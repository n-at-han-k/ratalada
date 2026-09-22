# frozen_string_literal: true
# /activitypub/user-id/{user-id}/outbox -- scaffolded from the document.

# List the user's recorded activity
get "/" do
  # params: user-id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/activitypub/user-id/{user-id}/outbox", type: :openapi do
  openapi_schema :public_api

  api_path "/activitypub/user-id/{user-id}/outbox" do
    parameter name: :"user-id", in: :path, schema: {"type" => "integer"}, required: true

    get "List the user's recorded activity" do
      tags "activitypub"
      operationId "activitypubPersonFeed"
      response 200, "Outbox" do
        schema(Schemas::ForgeOutbox)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/activitypub/user-id/{user-id}/outbox answers 200" do
    assert_api_response :get, 200, path_params: {"user-id": 0}
  end
end
