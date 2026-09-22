# frozen_string_literal: true
# /activitypub/repository-id/{repository-id}/inbox -- scaffolded from the document.

# Send to the inbox
post "/" do
  # params: repository-id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/activitypub/repository-id/{repository-id}/inbox", type: :openapi do
  openapi_schema :public_api

  api_path "/activitypub/repository-id/{repository-id}/inbox" do
    parameter name: :"repository-id", in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Send to the inbox" do
      tags "activitypub"
      operationId "activitypubRepositoryInbox"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::ForgeLike}},
      )
      response 204, "APIEmpty is an empty response"
    end
  end

  it "POST /api/v1/activitypub/repository-id/{repository-id}/inbox answers 204" do
    assert_api_response :post, 204, path_params: {"repository-id": 0}, body: {}
  end
end
