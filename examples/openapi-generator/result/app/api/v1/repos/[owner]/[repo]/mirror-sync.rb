# frozen_string_literal: true
# /repos/{owner}/{repo}/mirror-sync -- scaffolded from the document.

# Sync a mirrored repository
post "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/mirror-sync", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/mirror-sync" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    post "Sync a mirrored repository" do
      tags "repository"
      operationId "repoMirrorSync"
      response 200, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 413, "QuotaExceeded"
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/mirror-sync answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
