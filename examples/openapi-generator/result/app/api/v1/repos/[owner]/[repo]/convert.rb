# frozen_string_literal: true
# /repos/{owner}/{repo}/convert -- scaffolded from the document.

# Convert a mirror repo to a normal repo.
post "/" do
  content_type(:json)
  records = relations[:repository]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/convert", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/convert" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    post "Convert a mirror repo to a normal repo." do
      tags "repository"
      operationId "repoConvert"
      response 200, "Repository" do
        schema(Schemas::Repository)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/convert answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
