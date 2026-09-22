# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index}/requested_reviewers -- scaffolded from the document.

# Create review requests for a pull request
post "/" do
  content_type(:json)
  records = relations[:pull_review]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# Cancel review requests for a pull request
delete "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}/requested_reviewers", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}/requested_reviewers" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Create review requests for a pull request" do
      tags "repository"
      operationId "repoCreatePullReviewRequests"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::PullReviewRequestOptions}},
      )
      response 201, "PullReviewListWithoutPagination - Review requests without pagination headers" do
        schema({
  "type" => "array",
  "items" => Schemas::PullReview,
})
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
    end

    delete "Cancel review requests for a pull request" do
      tags "repository"
      operationId "repoDeletePullReviewRequests"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::PullReviewRequestOptions}},
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

  it "POST /api/v1/repos/{owner}/{repo}/pulls/{index}/requested_reviewers answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"reviewers" => [""], "team_reviewers" => [""]}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/pulls/{index}/requested_reviewers answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"reviewers" => [""], "team_reviewers" => [""]}
  end
end
