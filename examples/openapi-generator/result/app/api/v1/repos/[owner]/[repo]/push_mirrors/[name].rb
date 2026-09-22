# frozen_string_literal: true
# /repos/{owner}/{repo}/push_mirrors/{name} -- scaffolded from the document.

# Remove a push mirror from a repository by remoteName
delete "/" do
  records = relations[:push_mirror].where(:name => params["name"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get push mirror of the repository by remoteName
get "/" do
  content_type(:json)
  record = relations[:push_mirror].where(:name => params["name"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/push_mirrors/{name}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/push_mirrors/{name}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :name, in: :path, schema: {"type" => "string"}, required: true

    get "Get push mirror of the repository by remoteName" do
      tags "repository"
      operationId "repoGetPushMirrorByRemoteName"
      response 200, "PushMirror" do
        schema(Schemas::PushMirror)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Remove a push mirror from a repository by remoteName" do
      tags "repository"
      operationId "repoDeletePushMirror"
      response 204, "APIEmpty is an empty response"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/push_mirrors/{name} answers 200" do
    Factory[:push_mirror, :name => "name"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", name: "name"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/push_mirrors/{name} answers 204" do
    Factory[:push_mirror, :name => "name"]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", name: "name"}
  end
end
