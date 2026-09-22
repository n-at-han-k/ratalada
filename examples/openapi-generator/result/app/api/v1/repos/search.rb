# frozen_string_literal: true
# /repos/search -- scaffolded from the document.

# Search for repositories
get "/" do
  content_type(:json)
  record = relations[:search_results].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/search", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/search" do

    get "Search for repositories" do
      tags "repository"
      operationId "repoSearch"
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :topic, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :includeDesc, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :uid, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :priority_owner_id, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :team_id, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :starredBy, in: :query, schema: {"type" => "integer", "format" => "int64"}, required: false
      parameter name: :private, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :is_private, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :template, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :archived, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :mode, in: :query, schema: {"type" => "string"}, required: false
      parameter name: :exclusive, in: :query, schema: {"type" => "boolean"}, required: false
      parameter name: :sort, in: :query, schema: {
  "type" => "string",
  "enum" => [
    "alpha",
    "created",
    "updated",
    "size",
    "git_size",
    "lfs_size",
    "id",
    "stars",
    "forks",
  ],
}, required: false
      parameter name: :order, in: :query, schema: {"type" => "string", "enum" => ["asc", "desc"]}, required: false
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "SearchResults" do
        schema(Schemas::SearchResults)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/search answers 200" do
    Factory[:search_result]
    assert_api_response :get, 200
  end
end
