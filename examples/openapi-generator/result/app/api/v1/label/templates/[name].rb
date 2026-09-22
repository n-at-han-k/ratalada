# frozen_string_literal: true
# /label/templates/{name} -- scaffolded from the document.

# Returns all labels in a template
get "/" do
  content_type(:json)
  status(200)
  relations[:label_template].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/label/templates/{name}", type: :openapi do
  openapi_schema :public_api

  api_path "/label/templates/{name}" do
    parameter name: :name, in: :path, schema: {"type" => "string"}, required: true

    get "Returns all labels in a template" do
      tags "miscellaneous"
      operationId "getLabelTemplateInfo"
      response 200, "LabelTemplateInfo" do
        schema({
  "type" => "array",
  "items" => Schemas::LabelTemplate,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/label/templates/{name} answers 200" do
    Factory[:label_template]
    assert_api_response :get, 200, path_params: {name: "name"}
  end
end
