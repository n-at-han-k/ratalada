# frozen_string_literal: true
# /repos/{owner}/{repo}/git/notes/{sha} -- scaffolded from the document.

# Get a note corresponding to a single commit from a repository
get "/" do
  content_type(:json)
  record = relations[:note].where(:sha => params["sha"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Removes a note corresponding to a single commit from a repository
delete "/" do
  records = relations[:note].where(:sha => params["sha"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Set a note corresponding to a single commit from a repository
post "/" do
  content_type(:json)
  records = relations[:note]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/git/notes/{sha}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/git/notes/{sha}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :sha, in: :path, schema: {"type" => "string"}, required: true

    get "Get a note corresponding to a single commit from a repository" do
      tags "repository"
      operationId "repoGetNote"
      parameter name: :verification, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :files, in: :query, schema: {"type" => "boolean"}, required: false
      response 200, "Note" do
        schema(Schemas::Note)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    post "Set a note corresponding to a single commit from a repository" do
      tags "repository"
      operationId "repoSetNote"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::NoteOptions}},
      )
      response 200, "Note" do
        schema(Schemas::Note)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    delete "Removes a note corresponding to a single commit from a repository" do
      tags "repository"
      operationId "repoRemoveNote"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/git/notes/{sha} answers 200" do
    Factory[:note, :sha => "sha"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", sha: "sha"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/git/notes/{sha} answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", sha: "sha"}, body: {"message" => ""}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/git/notes/{sha} answers 204" do
    Factory[:note, :sha => "sha"]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", sha: "sha"}
  end
end
