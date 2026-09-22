# frozen_string_literal: true
# /teams/{id}/repos/{org}/{repo} -- scaffolded from the document.

# Add a repository to a team
put "/" do
  content_type(:json)
  records = relations[:repository].where(:repo => params["repo"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(204)
  record.to_h.to_json
end

# List a particular repo of team
get "/" do
  content_type(:json)
  record = relations[:repository].where(:repo => params["repo"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Remove a repository from a team
delete "/" do
  records = relations[:repository].where(:repo => params["repo"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/teams/{id}/repos/{org}/{repo}", type: :openapi do
  openapi_schema :public_api

  api_path "/teams/{id}/repos/{org}/{repo}" do
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "List a particular repo of team" do
      tags "organization"
      operationId "orgListTeamRepo"
      response 200, "Repository" do
        schema(Schemas::Repository)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Add a repository to a team" do
      tags "organization"
      operationId "orgAddTeamRepository"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Remove a repository from a team" do
      tags "organization"
      operationId "orgRemoveTeamRepository"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/teams/{id}/repos/{org}/{repo} answers 200" do
    Factory[:repository, :repo => "repo"]
    assert_api_response :get, 200, path_params: {id: 0, org: "org", repo: "repo"}
  end

  it "PUT /api/v1/teams/{id}/repos/{org}/{repo} answers 204" do
    Factory[:repository, :repo => "repo"]
    assert_api_response :put, 204, path_params: {id: 0, org: "org", repo: "repo"}
  end

  it "DELETE /api/v1/teams/{id}/repos/{org}/{repo} answers 204" do
    Factory[:repository, :repo => "repo"]
    assert_api_response :delete, 204, path_params: {id: 0, org: "org", repo: "repo"}
  end
end
