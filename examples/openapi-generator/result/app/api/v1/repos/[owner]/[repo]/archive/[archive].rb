# frozen_string_literal: true
# /repos/{owner}/{repo}/archive/{archive} -- scaffolded from the document.

# Get an archive of a repository
get "/" do
  # params: owner, repo, archive
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/archive/{archive}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/archive/{archive}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :archive, in: :path, schema: {"type" => "string"}, required: true

    get "Get an archive of a repository" do
      tags "repository"
      operationId "repoGetArchive"
      response 200, "success"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/archive/{archive} answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", archive: "archive"}
  end
end
