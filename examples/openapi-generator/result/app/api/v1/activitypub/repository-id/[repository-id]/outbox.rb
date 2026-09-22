# frozen_string_literal: true
# /activitypub/repository-id/{repository-id}/outbox -- scaffolded from the document.

# Display the outbox
post "/" do
  # params: repository-id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/activitypub/repository-id/{repository-id}/outbox", type: :openapi do
  openapi_schema :public_api

  api_path "/activitypub/repository-id/{repository-id}/outbox" do
    parameter name: :"repository-id", in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Display the outbox" do
      tags "activitypub"
      operationId "activitypubRepositoryOutbox"
      response 200, "Outbox" do
        schema(Schemas::ForgeOutbox)
      end
    end
  end

  it "POST /api/v1/activitypub/repository-id/{repository-id}/outbox answers 200" do
    assert_api_response :post, 200, path_params: {"repository-id": 0}
  end
end
