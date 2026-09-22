# frozen_string_literal: true
# /repos/{owner}/{repo}/tag_protections/{id} -- scaffolded from the document.

# Delete a specific tag protection for the repository
delete "/" do
  records = relations[:tag_protection].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Edit a tag protections for a repository. Only fields that are set will be changed
patch "/" do
  content_type(:json)
  records = relations[:tag_protection].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get a specific tag protection for the repository
get "/" do
  content_type(:json)
  record = relations[:tag_protection].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/tag_protections/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/tag_protections/{id}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a specific tag protection for the repository" do
      tags "repository"
      operationId "repoGetTagProtection"
      response 200, "TagProtection" do
        schema(Schemas::TagProtection)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a specific tag protection for the repository" do
      tags "repository"
      operationId "repoDeleteTagProtection"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Edit a tag protections for a repository. Only fields that are set will be changed" do
      tags "repository"
      operationId "repoEditTagProtection"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditTagProtectionOption}},
      )
      response 200, "TagProtection" do
        schema(Schemas::TagProtection)
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

  it "GET /api/v1/repos/{owner}/{repo}/tag_protections/{id} answers 200" do
    Factory[:tag_protection, :id => 1]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", id: 1}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/tag_protections/{id} answers 204" do
    Factory[:tag_protection, :id => 1]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", id: 1}
  end

  it "PATCH /api/v1/repos/{owner}/{repo}/tag_protections/{id} answers 200" do
    Factory[:tag_protection, :id => 1]
    assert_api_response :patch, 200, path_params: {owner: "owner", repo: "repo", id: 1}, body: {
      "name_pattern" => "",
      "whitelist_teams" => [""],
      "whitelist_usernames" => [""],
    }
  end
end
