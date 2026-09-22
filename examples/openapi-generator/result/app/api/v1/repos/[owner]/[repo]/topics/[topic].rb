# frozen_string_literal: true
# /repos/{owner}/{repo}/topics/{topic} -- scaffolded from the document.

# Add a topic to a repository
put "/" do
  # params: owner, repo, topic
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Delete a topic from a repository
delete "/" do
  # params: owner, repo, topic
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/topics/{topic}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/topics/{topic}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :topic, in: :path, schema: {"type" => "string"}, required: true

    put "Add a topic to a repository" do
      tags "repository"
      operationId "repoAddTopic"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIInvalidTopicsError is error format response to invalid topics" do
        schema(Schemas::APIInvalidTopicsError)
      end
    end

    delete "Delete a topic from a repository" do
      tags "repository"
      operationId "repoDeleteTopic"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIInvalidTopicsError is error format response to invalid topics" do
        schema(Schemas::APIInvalidTopicsError)
      end
    end
  end

  it "PUT /api/v1/repos/{owner}/{repo}/topics/{topic} answers 204" do
    assert_api_response :put, 204, path_params: {owner: "owner", repo: "repo", topic: "topic"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/topics/{topic} answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", topic: "topic"}
  end
end
