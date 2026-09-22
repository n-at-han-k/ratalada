# frozen_string_literal: true
# /activitypub/user-id/{user-id}/inbox -- scaffolded from the document.

# Send to the inbox
post "/" do
  # params: user-id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(202)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/activitypub/user-id/{user-id}/inbox", type: :openapi do
  openapi_schema :public_api

  api_path "/activitypub/user-id/{user-id}/inbox" do
    parameter name: :"user-id", in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Send to the inbox" do
      tags "activitypub"
      operationId "activitypubPersonInbox"
      response 202, "APIEmpty is an empty response"
    end
  end

  it "POST /api/v1/activitypub/user-id/{user-id}/inbox answers 202" do
    assert_api_response :post, 202, path_params: {"user-id": 0}
  end
end
