# frozen_string_literal: true
# /repos/{owner}/{repo}/hooks/git/{id} -- scaffolded from the document.

# Delete a Git hook in a repository
delete "/" do
  records = relations[:git_hook].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Edit a Git hook in a repository
patch "/" do
  content_type(:json)
  records = relations[:git_hook].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get a Git hook
get "/" do
  content_type(:json)
  record = relations[:git_hook].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/hooks/git/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/hooks/git/{id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "string"}, required: true

    get "Get a Git hook" do
      tags "repository"
      operationId "repoGetGitHook"
      response 200, "GitHook" do
        schema(Schemas::GitHook)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a Git hook in a repository" do
      tags "repository"
      operationId "repoDeleteGitHook"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Edit a Git hook in a repository" do
      tags "repository"
      operationId "repoEditGitHook"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditGitHookOption}},
      )
      response 200, "GitHook" do
        schema(Schemas::GitHook)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/hooks/git/{id} answers 200" do
    Factory[:git_hook, :id => "1"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", id: "1"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/hooks/git/{id} answers 204" do
    Factory[:git_hook, :id => "1"]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", id: "1"}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/hooks/git/{id} answers 200" do
    Factory[:git_hook, :id => "1"]
    assert_api_response :patch, 200, path_params: {owner: "owner", repo: "repo", id: "1"}, body: {"content" => ""}
  end
end
