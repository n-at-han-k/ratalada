# frozen_string_literal: true
# /repos/{owner}/{repo}/milestones -- scaffolded from the document.

# Create a milestone
post "/" do
  content_type(:json)
  records = relations[:milestone]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# Get all of a repository's opened milestones
get "/" do
  content_type(:json)
  status(200)
  relations[:milestone].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/milestones", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/milestones" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get all of a repository's opened milestones" do
      tags "issue"
      operationId "issueGetMilestonesList"
      parameter name: :state, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :name, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "MilestoneList" do
        schema({
  "type" => "array",
  "items" => Schemas::Milestone,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a milestone" do
      tags "issue"
      operationId "issueCreateMilestone"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateMilestoneOption}},
      )
      response 201, "Milestone" do
        schema(Schemas::Milestone)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/milestones answers 200" do
    Factory[:milestone]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/milestones answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
      "description" => "",
      "due_on" => "2026-01-01T00:00:00Z",
      "state" => "open",
      "title" => "",
    }
  end
end
