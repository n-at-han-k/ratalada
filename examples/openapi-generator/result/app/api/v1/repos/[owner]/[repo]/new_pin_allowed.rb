# frozen_string_literal: true
# /repos/{owner}/{repo}/new_pin_allowed -- scaffolded from the document.

# Returns if new Issue Pins are allowed
get "/" do
  content_type(:json)
  record = relations[:new_issue_pins_allowed].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/new_pin_allowed", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/new_pin_allowed" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Returns if new Issue Pins are allowed" do
      tags "repository"
      operationId "repoNewPinAllowed"
      response 200, "RepoNewIssuePinsAllowed" do
        schema(Schemas::NewIssuePinsAllowed)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/new_pin_allowed answers 200" do
    Factory[:new_issue_pins_allowed]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end
end
