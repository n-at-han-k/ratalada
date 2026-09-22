# frozen_string_literal: true
# /repos/{owner}/{repo}/issue_templates -- scaffolded from the document.

# Get available issue templates for a repository
get "/" do
  content_type(:json)
  status(200)
  relations[:issue_template].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issue_templates", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issue_templates" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get available issue templates for a repository" do
      tags "repository"
      operationId "repoGetIssueTemplates"
      response 200, "IssueTemplates" do
        schema({
  "type" => "array",
  "items" => Schemas::IssueTemplate,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issue_templates answers 200" do
    Factory[:issue_template]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
