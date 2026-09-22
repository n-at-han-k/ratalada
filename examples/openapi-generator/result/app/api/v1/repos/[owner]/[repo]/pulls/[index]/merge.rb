# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index}/merge -- scaffolded from the document.

# Cancel the scheduled auto merge for the given pull request
delete "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Merge a pull request
post "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

# Check if a pull request has been merged
get "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}/merge", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}/merge" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Check if a pull request has been merged" do
      tags "repository"
      operationId "repoPullRequestIsMerged"
      response 204, "pull request has been merged"
      response 404, "pull request has not been merged"
    end

    post "Merge a pull request" do
      tags "repository"
      operationId "repoMergePullRequest"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::MergePullRequestOption}},
      )
      response 200, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 405, "APIEmpty is an empty response"
      response 409, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 413, "QuotaExceeded"
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end

    delete "Cancel the scheduled auto merge for the given pull request" do
      tags "repository"
      operationId "repoCancelScheduledAutoMerge"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/pulls/{index}/merge answers 204" do
    assert_api_response :get, 204, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "POST /api/v1/repos/{owner}/{repo}/pulls/{index}/merge answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", index: 0}, body: {
      "Do" => "merge",
      "MergeCommitID" => "",
      "MergeMessageField" => "",
      "MergeTitleField" => "",
      "delete_branch_after_merge" => false,
      "force_merge" => false,
      "head_commit_id" => "",
      "merge_when_checks_succeed" => false,
    }
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/pulls/{index}/merge answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
