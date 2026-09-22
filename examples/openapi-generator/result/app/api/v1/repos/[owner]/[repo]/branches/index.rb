# frozen_string_literal: true
# /repos/{owner}/{repo}/branches -- scaffolded from the document.

# Create a branch
post "/" do
  content_type(:json)
  records = relations[:branch]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List a repository's branches
get "/" do
  content_type(:json)
  status(200)
  relations[:branch].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/branches", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/branches" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repository's branches" do
      tags "repository"
      operationId "repoListBranches"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "BranchList" do
        schema({
  "type" => "array",
  "items" => Schemas::Branch,
})
      end
    end

    post "Create a branch" do
      tags "repository"
      operationId "repoCreateBranch"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateBranchRepoOption}},
      )
      response 201, "Branch" do
        schema(Schemas::Branch)
      end
      response 403, "The branch is archived or a mirror."
      response 404, "The old branch does not exist."
      response 409, "The branch with the same name already exists."
      response 413, "QuotaExceeded"
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/branches answers 200" do
    Factory[:branch]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/branches answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
      "new_branch_name" => "",
      "old_branch_name" => "",
      "old_ref_name" => "",
    }
  end
end
