# frozen_string_literal: true
# /activitypub/user-id/{user-id} -- scaffolded from the document.

# Returns the Person actor for a user
get "/" do
  content_type(:json)
  record = relations[:activity_pub].where(:"user-id" => params["user-id"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/activitypub/user-id/{user-id}", type: :openapi do
  openapi_schema :public_api

  api_path "/activitypub/user-id/{user-id}" do
    parameter name: :"user-id", in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Returns the Person actor for a user" do
      tags "activitypub"
      operationId "activitypubPerson"
      response 200, "ActivityPub" do
        schema(Schemas::ActivityPub)
      end
    end
  end

  it "GET /api/v1/activitypub/user-id/{user-id} answers 200" do
    Factory[:activity_pub, :"user-id" => 0]
    assert_api_response :get, 200, path_params: {"user-id": 0}
  end
end
