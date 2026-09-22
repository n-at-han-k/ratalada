# frozen_string_literal: true
# /repos/{owner}/{repo}/avatar -- scaffolded from the document.

# Delete a repository's avatar
delete "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Update a repository's avatar
post "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/avatar", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/avatar" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    post "Update a repository's avatar" do
      tags "repository"
      operationId "repoUpdateAvatar"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::UpdateRepoAvatarOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a repository's avatar" do
      tags "repository"
      operationId "repoDeleteAvatar"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/avatar answers 204" do
    assert_api_response :post, 204, path_params: {owner: "owner", repo: "repo"}, body: {"image" => ""}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/avatar answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo"}
  end
end
