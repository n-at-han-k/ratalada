# frozen_string_literal: true
# /gitignore/templates -- scaffolded from the document.

# Returns a list of all gitignore templates
get "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  [""].to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/gitignore/templates", type: :openapi do
  openapi_schema :public_api

  api_path "/gitignore/templates" do

    get "Returns a list of all gitignore templates" do
      tags "miscellaneous"
      operationId "listGitignoresTemplates"
      response 200, "GitignoreTemplateList" do
        schema({"type" => "array", "items" => {"type" => "string"}})
      end
    end
  end

  it "GET /api/v1/gitignore/templates answers 200" do
    assert_api_response :get, 200
  end
end
