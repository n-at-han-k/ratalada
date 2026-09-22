# frozen_string_literal: true
# /licenses -- scaffolded from the document.

# Returns a list of all license templates
get "/" do
  content_type(:json)
  status(200)
  relations[:licenses_template_list_entry].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/licenses", type: :openapi do
  openapi_schema :public_api

  api_path "/licenses" do

    get "Returns a list of all license templates" do
      tags "miscellaneous"
      operationId "listLicenseTemplates"
      response 200, "LicenseTemplateList" do
        schema({
  "type" => "array",
  "items" => Schemas::LicensesTemplateListEntry,
})
      end
    end
  end

  it "GET /api/v1/licenses answers 200" do
    Factory[:licenses_template_list_entry]
    assert_api_response :get, 200
  end
end
