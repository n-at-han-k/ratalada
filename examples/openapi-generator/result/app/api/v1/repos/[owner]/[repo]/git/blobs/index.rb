# frozen_string_literal: true
# /repos/{owner}/{repo}/git/blobs -- scaffolded from the document.

# Gets multiple blobs of a repository.
get "/" do
  content_type(:json)
  status(200)
  relations[:git_blob].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/git/blobs", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/git/blobs" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Gets multiple blobs of a repository." do
      tags "repository"
      operationId "GetBlobs"
      parameter name: :shas, in: :query, schema: {"type" => "string"}, required: true
      response 200, "GitBlobList" do
        schema({
  "type" => "array",
  "items" => Schemas::GitBlob,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/git/blobs answers 200" do
    Factory[:git_blob]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}, params: {shas: ""}
  end
end
