# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{base}/{head} -- scaffolded from the document.

# Get a pull request by base and head
get "/" do
  content_type(:json)
  record = relations[:pull_request].where(:head => params["head"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{base}/{head}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{base}/{head}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :base, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :head, in: :path, schema: {"type" => "string"}, required: true

    get "Get a pull request by base and head" do
      tags "repository"
      operationId "repoGetPullRequestByBaseHead"
      response 200, "PullRequest" do
        schema(Schemas::PullRequest)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/pulls/{base}/{head} answers 200" do
    Factory[:pull_request, :head => "head"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", base: "base", head: "head"}
  end
end
