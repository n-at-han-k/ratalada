# frozen_string_literal: true
# /repos/{owner}/{repo}/collaborators/{collaborator} -- scaffolded from the document.

# Add a collaborator to a repository
put "/" do
  # params: owner, repo, collaborator
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Check if a user is a collaborator of a repository
get "/" do
  # params: owner, repo, collaborator
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Delete a collaborator from a repository
delete "/" do
  # params: owner, repo, collaborator
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/collaborators/{collaborator}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/collaborators/{collaborator}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :collaborator, in: :path, schema: {"type" => "string"}, required: true

    get "Check if a user is a collaborator of a repository" do
      tags "repository"
      operationId "repoCheckCollaborator"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    put "Add a collaborator to a repository" do
      tags "repository"
      operationId "repoAddCollaborator"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::AddCollaboratorOption}},
      )
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    delete "Delete a collaborator from a repository" do
      tags "repository"
      operationId "repoDeleteCollaborator"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/collaborators/{collaborator} answers 204" do
    assert_api_response :get, 204, path_params: {owner: "owner", repo: "repo", collaborator: "collaborator"}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/collaborators/{collaborator} answers 204" do
    assert_api_response :put, 204, path_params: {owner: "owner", repo: "repo", collaborator: "collaborator"}, body: {"permission" => "read"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/collaborators/{collaborator} answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", collaborator: "collaborator"}
  end
end
