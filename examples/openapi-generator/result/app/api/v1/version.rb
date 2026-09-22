# frozen_string_literal: true
# /version -- scaffolded from the document.

# Returns the version of the running application
get "/" do
  content_type(:json)
  record = relations[:server_version].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/version", type: :openapi do
  openapi_schema :public_api

  api_path "/version" do

    get "Returns the version of the running application" do
      tags "miscellaneous"
      operationId "getVersion"
      response 200, "ServerVersion" do
        schema(Schemas::ServerVersion)
      end
    end
  end

  it "GET /api/v1/version answers 200" do
    Factory[:server_version]
    assert_api_response :get, 200
  end
end
