# frozen_string_literal: true
# /repos/{owner}/{repo}/git/blobs/{sha} -- scaffolded from the document.

# Gets the blob of a repository.
get "/" do
  content_type(:json)
  record = relations[:git_blob].where(:sha => params["sha"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/git/blobs/{sha}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/git/blobs/{sha}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :sha, in: :path, schema: {"type" => "string"}, required: true

    get "Gets the blob of a repository." do
      tags "repository"
      operationId "GetBlob"
      response 200, "GitBlob" do
        schema(Schemas::GitBlob)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/git/blobs/{sha} answers 200" do
    Factory[:git_blob, :sha => "sha"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", sha: "sha"}
  end
end
