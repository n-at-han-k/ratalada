# frozen_string_literal: true
# /licenses/{name} -- scaffolded from the document.

# Returns information about a license template
get "/" do
  content_type(:json)
  record = relations[:license_template_info].where(:name => params["name"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/licenses/{name}", type: :openapi do
  openapi_schema :public_api

  api_path "/licenses/{name}" do
    parameter name: :name, in: :path, schema: {"type" => "string"}, required: true

    get "Returns information about a license template" do
      tags "miscellaneous"
      operationId "getLicenseTemplateInfo"
      response 200, "LicenseTemplateInfo" do
        schema(Schemas::LicenseTemplateInfo)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/licenses/{name} answers 200" do
    Factory[:license_template_info, :name => "name"]
    assert_api_response :get, 200, path_params: {name: "name"}
  end
end
