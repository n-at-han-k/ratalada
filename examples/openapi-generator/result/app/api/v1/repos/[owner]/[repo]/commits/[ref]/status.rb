# frozen_string_literal: true
# /repos/{owner}/{repo}/commits/{ref}/status -- scaffolded from the document.

# Get a commit's combined status, by branch/tag/commit reference
get "/" do
  content_type(:json)
  record = relations[:combined_status].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/commits/{ref}/status", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/commits/{ref}/status" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :ref, in: :path, schema: {"type" => "string"}, required: true

    get "Get a commit's combined status, by branch/tag/commit reference" do
      tags "repository"
      operationId "repoGetCombinedStatusByRef"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "CombinedStatus" do
        schema(Schemas::CombinedStatus)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/commits/{ref}/status answers 200" do
    Factory[:combined_status]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", ref: "ref"}
  end
end
