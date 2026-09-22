# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index}/reviews/{id} -- scaffolded from the document.

# Delete a specific review from a pull request
delete "/" do
  records = relations[:pull_review].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get a specific review for a pull request
get "/" do
  content_type(:json)
  record = relations[:pull_review].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Submit a pending review to an pull request
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
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}/reviews/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}/reviews/{id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a specific review for a pull request" do
      tags "repository"
      operationId "repoGetPullReview"
      response 200, "PullReview" do
        schema(Schemas::PullReview)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Submit a pending review to an pull request" do
      tags "repository"
      operationId "repoSubmitPullReview"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::SubmitPullReviewOptions}},
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

    delete "Delete a specific review from a pull request" do
      tags "repository"
      operationId "repoDeletePullReview"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews/{id} answers 200" do
    Factory[:pull_review, :id => 1]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0, id: 1}
  end

  it "POST /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews/{id} answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", index: 0, id: 1}, body: {"body" => "", "event" => ""}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/pulls/{index}/reviews/{id} answers 204" do
    Factory[:pull_review, :id => 1]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0, id: 1}
  end
end
