# frozen_string_literal: true
# /repos/{owner}/{repo}/keys/{id} -- scaffolded from the document.

# Delete a key from a repository
delete "/" do
  records = relations[:deploy_key].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get a repository's key by id
get "/" do
  content_type(:json)
  record = relations[:deploy_key].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/keys/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/keys/{id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a repository's key by id" do
      tags "repository"
      operationId "repoGetKey"
      response 200, "DeployKey" do
        schema(Schemas::DeployKey)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a key from a repository" do
      tags "repository"
      operationId "repoDeleteKey"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/keys/{id} answers 200" do
    Factory[:deploy_key, :id => 1]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", id: 1}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/keys/{id} answers 204" do
    Factory[:deploy_key, :id => 1]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", id: 1}
  end
end
