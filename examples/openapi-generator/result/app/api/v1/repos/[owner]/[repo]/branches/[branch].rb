# frozen_string_literal: true
# /repos/{owner}/{repo}/branches/{branch} -- scaffolded from the document.

# Delete a specific branch from a repository
delete "/" do
  records = relations[:branch].where(:branch => params["branch"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Retrieve a specific branch from a repository, including its effective branch protection
get "/" do
  content_type(:json)
  record = relations[:branch].where(:branch => params["branch"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Update a branch
patch "/" do
  content_type(:json)
  records = relations[:branch].where(:branch => params["branch"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(204)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/branches/{branch}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/branches/{branch}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :branch, in: :path, schema: {"type" => "string"}, required: true

    get "Retrieve a specific branch from a repository, including its effective branch protection" do
      tags "repository"
      operationId "repoGetBranch"
      response 200, "Branch" do
        schema(Schemas::Branch)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a specific branch from a repository" do
      tags "repository"
      operationId "repoDeleteBranch"
      response 204, "APIEmpty is an empty response"
      response 403, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end

    patch "Update a branch" do
      tags "repository"
      operationId "repoUpdateBranch"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::UpdateBranchRepoOption}},
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
  end

  it "GET /api/v1/repos/{owner}/{repo}/branches/{branch} answers 200" do
    Factory[:branch, :branch => "branch"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", branch: "branch"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/branches/{branch} answers 204" do
    Factory[:branch, :branch => "branch"]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", branch: "branch"}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/branches/{branch} answers 204" do
    Factory[:branch, :branch => "branch"]
    assert_api_response :patch, 204, path_params: {owner: "owner", repo: "repo", branch: "branch"}, body: {"name" => ""}
  end
end
