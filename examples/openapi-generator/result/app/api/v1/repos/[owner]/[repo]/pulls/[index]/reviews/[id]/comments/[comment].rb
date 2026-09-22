# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments/{comment} -- scaffolded from the document.

# Delete a pull review comment
delete "/" do
  records = relations[:pull_review_comment].where(:comment => params["comment"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get a pull review comment
get "/" do
  content_type(:json)
  record = relations[:pull_review_comment].where(:comment => params["comment"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments/{comment}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments/{comment}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :comment, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a pull review comment" do
      tags "repository"
      operationId "repoGetPullReviewComment"
      response 200, "PullComment" do
        schema(Schemas::PullReviewComment)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a pull review comment" do
      tags "repository"
      operationId "repoDeletePullReviewComment"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments/{comment} answers 200" do
    Factory[:pull_review_comment, :comment => 0]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0, id: 0, comment: 0}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/comments/{comment} answers 204" do
    Factory[:pull_review_comment, :comment => 0]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0, id: 0, comment: 0}
  end
end
