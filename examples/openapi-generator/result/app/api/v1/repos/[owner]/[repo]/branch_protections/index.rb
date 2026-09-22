# frozen_string_literal: true
# /repos/{owner}/{repo}/branch_protections -- scaffolded from the document.

# Create a branch protections for a repository
post "/" do
  content_type(:json)
  records = relations[:branch_protection]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List branch protections for a repository
get "/" do
  content_type(:json)
  status(200)
  relations[:branch_protection].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/branch_protections", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/branch_protections" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List branch protections for a repository" do
      tags "repository"
      operationId "repoListBranchProtection"
      response 200, "BranchProtectionList" do
        schema({
  "type" => "array",
  "items" => Schemas::BranchProtection,
})
      end
    end

    post "Create a branch protections for a repository" do
      tags "repository"
      operationId "repoCreateBranchProtection"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateBranchProtectionOption}},
      )
      response 201, "BranchProtection" do
        schema(Schemas::BranchProtection)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
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

  it "GET /api/v1/repos/{owner}/{repo}/branch_protections answers 200" do
    Factory[:branch_protection]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/branch_protections answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
      "apply_to_admins" => false,
      "approvals_whitelist_teams" => [""],
      "approvals_whitelist_username" => [""],
      "block_on_official_review_requests" => false,
      "block_on_outdated_branch" => false,
      "block_on_rejected_reviews" => false,
      "branch_name" => "",
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
      "rule_name" => "",
      "status_check_contexts" => [""],
      "unprotected_file_patterns" => "",
    }
  end
end
