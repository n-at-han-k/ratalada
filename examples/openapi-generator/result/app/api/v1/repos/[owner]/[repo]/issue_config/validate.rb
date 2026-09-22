# frozen_string_literal: true
# /repos/{owner}/{repo}/issue_config/validate -- scaffolded from the document.

# Returns the validation information for a issue config
get "/" do
  content_type(:json)
  record = relations[:issue_config_validation].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issue_config/validate", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issue_config/validate" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Returns the validation information for a issue config" do
      tags "repository"
      operationId "repoValidateIssueConfig"
      response 200, "RepoIssueConfigValidation" do
        schema(Schemas::IssueConfigValidation)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issue_config/validate answers 200" do
    Factory[:issue_config_validation]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
