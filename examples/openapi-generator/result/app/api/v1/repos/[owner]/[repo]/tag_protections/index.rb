# frozen_string_literal: true
# /repos/{owner}/{repo}/tag_protections -- scaffolded from the document.

# Create a tag protections for a repository
post "/" do
  content_type(:json)
  records = relations[:tag_protection]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List tag protections for a repository
get "/" do
  content_type(:json)
  status(200)
  relations[:tag_protection].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/tag_protections", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/tag_protections" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List tag protections for a repository" do
      tags "repository"
      operationId "repoListTagProtection"
      response 200, "TagProtectionList" do
        schema({
  "type" => "array",
  "items" => Schemas::TagProtection,
})
      end
    end

    post "Create a tag protections for a repository" do
      tags "repository"
      operationId "repoCreateTagProtection"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateTagProtectionOption}},
      )
      response 201, "TagProtection" do
        schema(Schemas::TagProtection)
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
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/tag_protections answers 200" do
    Factory[:tag_protection]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/tag_protections answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
      "name_pattern" => "",
      "whitelist_teams" => [""],
      "whitelist_usernames" => [""],
    }
  end
end
