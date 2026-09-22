# frozen_string_literal: true
# /markup -- scaffolded from the document.

# Render a markup document as HTML
post "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  "".to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/markup", type: :openapi do
  openapi_schema :public_api

  api_path "/markup" do

    post "Render a markup document as HTML" do
      tags "miscellaneous"
      operationId "renderMarkup"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::MarkupOption}},
      )
      response 200, "MarkupRender is a rendered markup document" do
        schema({"type" => "string"})
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/markup answers 200" do
    assert_api_response :post, 200, body: {
      "BranchPath" => "",
      "Context" => "",
      "FilePath" => "",
      "Mode" => "",
      "Text" => "",
      "Wiki" => false,
    }
  end
end
