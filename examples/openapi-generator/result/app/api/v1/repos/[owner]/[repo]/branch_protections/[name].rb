# frozen_string_literal: true
# /repos/{owner}/{repo}/branch_protections/{name} -- scaffolded from the document.

# Delete a specific branch protection for the repository
delete "/" do
  records = relations[:branch_protection].where(:name => params["name"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Edit a branch protections for a repository. Only fields that are set will be changed
patch "/" do
  content_type(:json)
  records = relations[:branch_protection].where(:name => params["name"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get a specific branch protection for the repository
get "/" do
  content_type(:json)
  record = relations[:branch_protection].where(:name => params["name"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/branch_protections/{name}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/branch_protections/{name}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :name, in: :path, schema: {"type" => "string"}, required: true

    get "Get a specific branch protection for the repository" do
      tags "repository"
      operationId "repoGetBranchProtection"
      response 200, "BranchProtection" do
        schema(Schemas::BranchProtection)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a specific branch protection for the repository" do
      tags "repository"
      operationId "repoDeleteBranchProtection"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Edit a branch protections for a repository. Only fields that are set will be changed" do
      tags "repository"
      operationId "repoEditBranchProtection"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditBranchProtectionOption}},
      )
      response 200, "BranchProtection" do
        schema(Schemas::BranchProtection)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/branch_protections/{name} answers 200" do
    Factory[:branch_protection, :name => "name"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", name: "name"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/branch_protections/{name} answers 204" do
    Factory[:branch_protection, :name => "name"]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", name: "name"}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/branch_protections/{name} answers 200" do
    Factory[:branch_protection, :name => "name"]
    assert_api_response :patch, 200, path_params: {owner: "owner", repo: "repo", name: "name"}, body: {
      "apply_to_admins" => false,
      "approvals_whitelist_teams" => [""],
      "approvals_whitelist_username" => [""],
      "block_on_official_review_requests" => false,
      "block_on_outdated_branch" => false,
      "block_on_rejected_reviews" => false,
      "dismiss_stale_approvals" => false,
      "enable_approvals_whitelist" => false,
      "enable_merge_whitelist" => false,
      "enable_push" => false,
      "enable_push_whitelist" => false,
      "enable_status_check" => false,
      "ignore_stale_approvals" => false,
      "merge_whitelist_teams" => [""],
      "merge_whitelist_usernames" => [""],
      "protected_file_patterns" => "",
      "push_whitelist_deploy_keys" => false,
      "push_whitelist_teams" => [""],
      "push_whitelist_usernames" => [""],
      "require_signed_commits" => false,
      "required_approvals" => 0,
      "status_check_contexts" => [""],
      "unprotected_file_patterns" => "",
    }
  end
end
