# frozen_string_literal: true
# /activitypub/repository-id/{repository-id} -- scaffolded from the document.

# Returns the Repository actor for a repo
get "/" do
  content_type(:json)
  record = relations[:activity_pub].where(:"repository-id" => params["repository-id"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/activitypub/repository-id/{repository-id}", type: :openapi do
  openapi_schema :public_api

  api_path "/activitypub/repository-id/{repository-id}" do
    parameter name: :"repository-id", in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Returns the Repository actor for a repo" do
      tags "activitypub"
      operationId "activitypubRepository"
      response 200, "ActivityPub" do
        schema(Schemas::ActivityPub)
      end
    end
  end

  it "GET /api/v1/activitypub/repository-id/{repository-id} answers 200" do
    Factory[:activity_pub, :"repository-id" => 0]
    assert_api_response :get, 200, path_params: {"repository-id": 0}
  end
end
