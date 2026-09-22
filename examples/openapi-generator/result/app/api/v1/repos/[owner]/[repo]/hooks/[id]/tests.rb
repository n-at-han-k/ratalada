# frozen_string_literal: true
# /repos/{owner}/{repo}/hooks/{id}/tests -- scaffolded from the document.

# Test a push webhook
post "/" do
  # params: owner, repo, id
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/hooks/{id}/tests", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/hooks/{id}/tests" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Test a push webhook" do
      tags "repository"
      operationId "repoTestHook"
      parameter name: :ref, in: :query, schema: {"type" => "string"}, required: false
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/hooks/{id}/tests answers 204" do
    assert_api_response :post, 204, path_params: {owner: "owner", repo: "repo", id: 0}
  end
end
