# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/variables/{variablename} -- scaffolded from the document.

# Create a repo-level variable
post "/" do
  content_type(:json)
  records = relations[:action_variable]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# Delete a repo-level variable
delete "/" do
  records = relations[:action_variable].where(:variablename => params["variablename"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get a repo-level variable
get "/" do
  content_type(:json)
  record = relations[:action_variable].where(:variablename => params["variablename"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Update a repo-level variable
put "/" do
  content_type(:json)
  records = relations[:action_variable].where(:variablename => params["variablename"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/variables/{variablename}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/variables/{variablename}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :variablename, in: :path, schema: {"type" => "string"}, required: true

    get "Get a repo-level variable" do
      tags "repository"
      operationId "getRepoVariable"
      response 200, "ActionVariable" do
        schema(Schemas::ActionVariable)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Update a repo-level variable" do
      tags "repository"
      operationId "updateRepoVariable"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::UpdateVariableOption}},
      )
      response 201, "response when updating a repo-level variable"
      response 204, "response when updating a repo-level variable"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a repo-level variable" do
      tags "repository"
      operationId "createRepoVariable"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateVariableOption}},
      )
      response 201, "response when creating a repo-level variable"
      response 204, "response when creating a repo-level variable"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a repo-level variable" do
      tags "repository"
      operationId "deleteRepoVariable"
      response 204, "response when deleting a variable"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/actions/variables/{variablename} answers 200" do
    Factory[:action_variable, :variablename => "variablename"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", variablename: "variablename"}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/actions/variables/{variablename} answers 201" do
    Factory[:action_variable, :variablename => "variablename"]
    assert_api_response :put, 201, path_params: {owner: "owner", repo: "repo", variablename: "variablename"}, body: {"name" => "", "value" => ""}
  end

  it "POST /api/v1/repos/{owner}/{repo}/actions/variables/{variablename} answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", variablename: "variablename"}, body: {"value" => ""}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/actions/variables/{variablename} answers 204" do
    Factory[:action_variable, :variablename => "variablename"]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", variablename: "variablename"}
  end
end
