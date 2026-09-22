# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments -- scaffolded from the document.

# Add a new comment to a pull request review
post "/" do
  content_type(:json)
  records = relations[:pull_review_comment]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(200)
  record.to_h.to_json
end

# Get a specific review for a pull request
get "/" do
  content_type(:json)
  status(200)
  relations[:pull_review_comment].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a specific review for a pull request" do
      tags "repository"
      operationId "repoGetPullReviewComments"
      response 200, "PullCommentList" do
        schema({
  "type" => "array",
  "items" => Schemas::PullReviewComment,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Add a new comment to a pull request review" do
      tags "repository"
      operationId "repoCreatePullReviewComment"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::CreatePullReviewCommentOptions}},
      )
      response 200, "PullComment" do
        schema(Schemas::PullReviewComment)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments answers 200" do
    Factory[:pull_review_comment]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0, id: 0}
  end

  it "POST /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", index: 0, id: 0}, body: {}
  end
end
