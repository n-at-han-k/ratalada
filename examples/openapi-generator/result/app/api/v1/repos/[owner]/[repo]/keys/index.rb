# frozen_string_literal: true
# /repos/{owner}/{repo}/keys -- scaffolded from the document.

# Add a key to a repository
post "/" do
  content_type(:json)
  records = relations[:deploy_key]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List a repository's keys
get "/" do
  content_type(:json)
  status(200)
  relations[:deploy_key].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/keys", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/keys" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a repository's keys" do
      tags "repository"
      operationId "repoListKeys"
      parameter name: :key_id, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :fingerprint, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "DeployKeyList" do
        schema({
  "type" => "array",
  "items" => Schemas::DeployKey,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Add a key to a repository" do
      tags "repository"
      operationId "repoCreateKey"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateKeyOption}},
      )
      response 201, "DeployKey" do
        schema(Schemas::DeployKey)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/keys answers 200" do
    Factory[:deploy_key]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/keys answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {"key" => "", "read_only" => false, "title" => ""}
  end
end
