# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/runners -- scaffolded from the document.

# Get runners belonging to the repository
get "/" do
  content_type(:json)
  status(200)
  relations[:action_runner].to_a.map(&:to_h).to_json
end

# Register a new repository-level runner
post "/" do
  content_type(:json)
  records = relations[:register_runner_response]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/runners", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/runners" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get runners belonging to the repository" do
      tags "repository"
      operationId "getRepoRunners"
      parameter name: :visible, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "ActionRunnerList is a list of Forgejo Action runners" do
        schema({
  "type" => "array",
  "items" => Schemas::ActionRunner,
})
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Register a new repository-level runner" do
      tags "repository"
      operationId "registerRepoRunner"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::RegisterRunnerOptions}},
      )
      response 201, "RegisterRunnerResponse contains the details of the just registered runner." do
        schema(Schemas::RegisterRunnerResponse)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/actions/runners answers 200" do
    Factory[:action_runner]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/actions/runners answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {"description" => "", "ephemeral" => false, "name" => ""}
  end
end
