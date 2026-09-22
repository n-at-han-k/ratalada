# frozen_string_literal: true
# /activitypub/actor -- scaffolded from the document.

# Returns the instance's Actor
get "/" do
  content_type(:json)
  record = relations[:activity_pub].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/activitypub/actor", type: :openapi do
  openapi_schema :public_api

  api_path "/activitypub/actor" do

    get "Returns the instance's Actor" do
      tags "activitypub"
      operationId "activitypubInstanceActor"
      response 200, "ActivityPub" do
        schema(Schemas::ActivityPub)
      end
    end
  end

  it "GET /api/v1/activitypub/actor answers 200" do
    Factory[:activity_pub]
    assert_api_response :get, 200
  end
end
