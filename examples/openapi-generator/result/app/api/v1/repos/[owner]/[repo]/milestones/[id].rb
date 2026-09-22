# frozen_string_literal: true
# /repos/{owner}/{repo}/milestones/{id} -- scaffolded from the document.

# Delete a milestone
delete "/" do
  records = relations[:milestone].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Update a milestone
patch "/" do
  content_type(:json)
  records = relations[:milestone].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get a milestone
get "/" do
  content_type(:json)
  record = relations[:milestone].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/milestones/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/milestones/{id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a milestone" do
      tags "issue"
      operationId "issueGetMilestone"
      response 200, "Milestone" do
        schema(Schemas::Milestone)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a milestone" do
      tags "issue"
      operationId "issueDeleteMilestone"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Update a milestone" do
      tags "issue"
      operationId "issueEditMilestone"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditMilestoneOption}},
      )
      response 200, "Milestone" do
        schema(Schemas::Milestone)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/milestones/{id} answers 200" do
    Factory[:milestone, :id => 1]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", id: 1}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/milestones/{id} answers 204" do
    Factory[:milestone, :id => 1]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", id: 1}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/milestones/{id} answers 200" do
    Factory[:milestone, :id => 1]
    assert_api_response :patch, 200, path_params: {owner: "owner", repo: "repo", id: 1}, body: {
      "description" => "",
      "due_on" => "2026-01-01T00:00:00Z",
      "state" => "",
      "title" => "",
    }
  end
end
