# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index}/reviews/{id}/undismissals -- scaffolded from the document.

# Cancel to dismiss a review for a pull request
post "/" do
  content_type(:json)
  records = relations[:pull_review]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/undismissals", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/undismissals" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Cancel to dismiss a review for a pull request" do
      tags "repository"
      operationId "repoUnDismissPullReview"
      response 200, "PullReview" do
        schema(Schemas::PullReview)
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
  end

  it "POST /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews/{id}/undismissals answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", index: 0, id: 0}
  end
end
