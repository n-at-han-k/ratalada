# frozen_string_literal: true
# /repos/{owner}/{repo}/hooks -- scaffolded from the document.

# Create a hook
post "/" do
  content_type(:json)
  records = relations[:hook]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List the hooks in a repository
get "/" do
  content_type(:json)
  status(200)
  relations[:hook].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/hooks", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/hooks" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List the hooks in a repository" do
      tags "repository"
      operationId "repoListHooks"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "HookList" do
        schema({
  "type" => "array",
  "items" => Schemas::Hook,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a hook" do
      tags "repository"
      operationId "repoCreateHook"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateHookOption}},
      )
      response 201, "Hook" do
        schema(Schemas::Hook)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/hooks answers 200" do
    Factory[:hook]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/hooks answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
      "active" => false,
      "authorization_header" => "",
      "branch_filter" => "",
      "config" => {},
      "events" => [""],
      "type" => "forgejo",
    }
  end
end
