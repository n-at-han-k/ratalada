# frozen_string_literal: true
# /repos/{owner}/{repo}/pulls/{index} -- scaffolded from the document.

# Update a pull request. If using deadline only the date will be taken into account, and time of day ignored.
patch "/" do
  content_type(:json)
  records = relations[:pull_request].where(:index => params["index"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(201)
  record.to_h.to_json
end

# Get a pull request
get "/" do
  content_type(:json)
  record = relations[:pull_request].where(:index => params["index"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/pulls/{index}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/pulls/{index}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a pull request" do
      tags "repository"
      operationId "repoGetPullRequest"
      response 200, "PullRequest" do
        schema(Schemas::PullRequest)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Update a pull request. If using deadline only the date will be taken into account, and time of day ignored." do
      tags "repository"
      operationId "repoEditPullRequest"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditPullRequestOption}},
      )
      response 201, "PullRequest" do
        schema(Schemas::PullRequest)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 412, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/pulls/{index} answers 200" do
    Factory[:pull_request, :index => 0]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/pulls/{index} answers 201" do
    Factory[:pull_request, :index => 0]
    assert_api_response :patch, 201, path_params: {owner: "owner", repo: "repo", index: 0}, body: {
      "allow_maintainer_edit" => false,
      "assignee" => "",
      "assignees" => [""],
      "base" => "",
      "body" => "",
      "due_date" => "2026-01-01T00:00:00Z",
      "labels" => [0],
      "milestone" => 0,
      "state" => "",
      "title" => "",
      "unset_due_date" => false,
    }
  end
end
