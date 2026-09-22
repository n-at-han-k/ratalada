# frozen_string_literal: true
# /repos/{owner}/{repo}/signing-key.gpg -- scaffolded from the document.

# Get signing-key.gpg for given repository
get "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  "".to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/signing-key.gpg", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/signing-key.gpg" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get signing-key.gpg for given repository" do
      tags "repository"
      operationId "repoSigningKey"
      response 200, "GPG armored public key" do
        schema({"type" => "string"})
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/signing-key.gpg answers 200" do
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
