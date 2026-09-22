# frozen_string_literal: true
# /repos/{owner}/{repo}/teams/{team} -- scaffolded from the document.

# Add a team to a repository
put "/" do
  content_type(:json)
  records = relations[:team].where(:team => params["team"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(204)
  record.to_h.to_json
end

# Check if a team is assigned to a repository
get "/" do
  content_type(:json)
  record = relations[:team].where(:team => params["team"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Delete a team from a repository
delete "/" do
  records = relations[:team].where(:team => params["team"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/teams/{team}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/teams/{team}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :team, in: :path, schema: {"type" => "string"}, required: true

    get "Check if a team is assigned to a repository" do
      tags "repository"
      operationId "repoCheckTeam"
      response 200, "Team" do
        schema(Schemas::Team)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 405, "APIError is error format response" do
        schema(Schemas::APIError)
      end
    end

    put "Add a team to a repository" do
      tags "repository"
      operationId "repoAddTeam"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 405, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    delete "Delete a team from a repository" do
      tags "repository"
      operationId "repoDeleteTeam"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 405, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/teams/{team} answers 200" do
    Factory[:team, :team => "team"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", team: "team"}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/teams/{team} answers 204" do
    Factory[:team, :team => "team"]
    assert_api_response :put, 204, path_params: {owner: "owner", repo: "repo", team: "team"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/teams/{team} answers 204" do
    Factory[:team, :team => "team"]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", team: "team"}
  end
end
