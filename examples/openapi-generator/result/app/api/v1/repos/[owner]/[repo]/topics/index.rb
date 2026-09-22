# frozen_string_literal: true
# /repos/{owner}/{repo}/topics -- scaffolded from the document.

# Get list of topics that a repository has
get "/" do
  content_type(:json)
  record = relations[:topic_name].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Replace list of topics for a repository
put "/" do
  content_type(:json)
  records = relations[:topic_name]
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(204)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/topics", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/topics" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get list of topics that a repository has" do
      tags "repository"
      operationId "repoListTopics"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "TopicNames" do
        schema(Schemas::TopicName)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Replace list of topics for a repository" do
      tags "repository"
      operationId "repoUpdateTopics"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::RepoTopicOptions}},
      )
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIInvalidTopicsError is error format response to invalid topics" do
        schema(Schemas::APIInvalidTopicsError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/topics answers 200" do
    Factory[:topic_name]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/topics answers 204" do
    Factory[:topic_name]
    assert_api_response :put, 204, path_params: {owner: "owner", repo: "repo"}, body: {"topics" => [""]}
  end
end
