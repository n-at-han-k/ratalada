# frozen_string_literal: true
# /nodeinfo -- scaffolded from the document.

# Returns the nodeinfo of the Forgejo application
get "/" do
  content_type(:json)
  record = relations[:node_info].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/nodeinfo", type: :openapi do
  openapi_schema :public_api

  api_path "/nodeinfo" do

    get "Returns the nodeinfo of the Forgejo application" do
      tags "miscellaneous"
      operationId "getNodeInfo"
      response 200, "NodeInfo" do
        schema(Schemas::NodeInfo)
      end
    end
  end

  it "GET /api/v1/nodeinfo answers 200" do
    Factory[:node_info]
    assert_api_response :get, 200
  end
end
