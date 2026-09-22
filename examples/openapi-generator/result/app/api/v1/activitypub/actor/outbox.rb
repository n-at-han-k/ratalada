# frozen_string_literal: true
# /activitypub/actor/outbox -- scaffolded from the document.

# Display the outbox (always empty)
post "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/activitypub/actor/outbox", type: :openapi do
  openapi_schema :public_api

  api_path "/activitypub/actor/outbox" do

    post "Display the outbox (always empty)" do
      tags "activitypub"
      operationId "activitypubInstanceActorOutbox"
      response 200, "Outbox" do
        schema(Schemas::ForgeOutbox)
      end
    end
  end

  it "POST /api/v1/activitypub/actor/outbox answers 200" do
    assert_api_response :post, 200
  end
end
