# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index}/reviews -- scaffolded from the document.

# Create a review to an pull request
post "/" do
  content_type(:json)
  records = relations[:pull_review]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(200)
  record.to_h.to_json
end

# List all reviews for a pull request
get "/" do
  content_type(:json)
  status(200)
  relations[:pull_review].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}/reviews", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}/reviews" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "List all reviews for a pull request" do
      tags "repository"
      operationId "repoListPullReviews"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "PullReviewList" do
        schema({
  "type" => "array",
  "items" => Schemas::PullReview,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a review to an pull request" do
      tags "repository"
      operationId "repoCreatePullReview"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::CreatePullReviewOptions}},
      )
      response 200, "PullReview" do
        schema(Schemas::PullReview)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews answers 200" do
    Factory[:pull_review]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "POST /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", index: 0}, body: {
      "body" => "",
      "comments" => [
        {
          "body" => "",
          "extra_lines_count" => 0,
          "new_position" => 0,
          "old_position" => 0,
          "path" => "",
        },
      ],
      "commit_id" => "",
      "event" => "",
    }
  end
end
