# frozen_string_literal: true
# /repos/{owner}/{repo}/compare/{basehead} -- scaffolded from the document.

# Get commit comparison information
get "/" do
  content_type(:json)
  record = relations[:compare].where(:basehead => params["basehead"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/compare/{basehead}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/compare/{basehead}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :basehead, in: :path, schema: {"type" => "string"}, required: true

    get "Get commit comparison information" do
      tags "repository"
      operationId "repoCompareDiff"
      parameter name: :verification, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :files, in: :query, schema: {"type" => "boolean"}, required: false
      response 200, "" do
        schema(Schemas::Compare)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/compare/{basehead} answers 200" do
    Factory[:compare, :basehead => "basehead"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", basehead: "basehead"}
  end
end
