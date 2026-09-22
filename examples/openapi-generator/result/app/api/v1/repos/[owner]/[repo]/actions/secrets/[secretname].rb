# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/secrets/{secretname} -- scaffolded from the document.

# Delete a secret in a repository
delete "/" do
  # params: owner, repo, secretname
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Create or Update a secret value in a repository
put "/" do
  # params: owner, repo, secretname
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/secrets/{secretname}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/secrets/{secretname}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :secretname, in: :path, schema: {"type" => "string"}, required: true

    put "Create or Update a secret value in a repository" do
      tags "repository"
      operationId "updateRepoSecret"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateOrUpdateSecretOption}},
      )
      response 201, "response when creating a secret"
      response 204, "response when updating a secret"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a secret in a repository" do
      tags "repository"
      operationId "deleteRepoSecret"
      response 204, "delete one secret of the organization"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "PUT /api/v1/repos/{owner}/{repo}/actions/secrets/{secretname} answers 201" do
    assert_api_response :put, 201, path_params: {owner: "owner", repo: "repo", secretname: "secretname"}, body: {"data" => ""}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/actions/secrets/{secretname} answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", secretname: "secretname"}
  end
end
