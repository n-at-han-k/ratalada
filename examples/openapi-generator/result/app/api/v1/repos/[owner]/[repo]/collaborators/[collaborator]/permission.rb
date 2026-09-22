# frozen_string_literal: true
# /repos/{owner}/{repo}/collaborators/{collaborator}/permission -- scaffolded from the document.

# Get repository permissions for a user
get "/" do
  content_type(:json)
  record = relations[:repo_collaborator_permission].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/collaborators/{collaborator}/permission", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/collaborators/{collaborator}/permission" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :collaborator, in: :path, schema: {"type" => "string"}, required: true

    get "Get repository permissions for a user" do
      tags "repository"
      operationId "repoGetRepoPermissions"
      response 200, "RepoCollaboratorPermission" do
        schema(Schemas::RepoCollaboratorPermission)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/collaborators/{collaborator}/permission answers 200" do
    Factory[:repo_collaborator_permission]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", collaborator: "collaborator"}
  end
end
