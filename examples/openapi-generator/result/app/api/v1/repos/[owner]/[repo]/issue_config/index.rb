# frozen_string_literal: true
# /repos/{owner}/{repo}/issue_config -- scaffolded from the document.

# Returns the issue config for a repo
get "/" do
  content_type(:json)
  record = relations[:issue_config].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issue_config", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issue_config" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Returns the issue config for a repo" do
      tags "repository"
      operationId "repoGetIssueConfig"
      response 200, "RepoIssueConfig" do
        schema(Schemas::IssueConfig)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issue_config answers 200" do
    Factory[:issue_config]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
