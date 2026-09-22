# frozen_string_literal: true
# /activitypub/actor/inbox -- scaffolded from the document.

# Send to the inbox
post "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/activitypub/actor/inbox", type: :openapi do
  openapi_schema :public_api

  api_path "/activitypub/actor/inbox" do

    post "Send to the inbox" do
      tags "activitypub"
      operationId "activitypubInstanceActorInbox"
      response 204, "APIEmpty is an empty response"
    end
  end

  it "POST /api/v1/activitypub/actor/inbox answers 204" do
    assert_api_response :post, 204
  end
end
