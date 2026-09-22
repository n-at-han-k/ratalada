# frozen_string_literal: true
# /repos/{owner}/{repo}/push_mirrors -- scaffolded from the document.

# Set up a new push mirror in a repository
post "/" do
  content_type(:json)
  records = relations[:push_mirror]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(200)
  record.to_h.to_json
end

# Get all push mirrors of the repository
get "/" do
  content_type(:json)
  status(200)
  relations[:push_mirror].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/push_mirrors", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/push_mirrors" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get all push mirrors of the repository" do
      tags "repository"
      operationId "repoListPushMirrors"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "PushMirrorList" do
        schema({
  "type" => "array",
  "items" => Schemas::PushMirror,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Set up a new push mirror in a repository" do
      tags "repository"
      operationId "repoAddPushMirror"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreatePushMirrorOption}},
      )
      response 200, "PushMirror" do
        schema(Schemas::PushMirror)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 413, "QuotaExceeded"
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/push_mirrors answers 200" do
    Factory[:push_mirror]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/push_mirrors answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo"}, body: {
      "branch_filter" => "",
      "interval" => "",
      "remote_address" => "",
      "remote_password" => "",
      "remote_username" => "",
      "sync_on_commit" => false,
      "use_ssh" => false,
    }
  end
end
