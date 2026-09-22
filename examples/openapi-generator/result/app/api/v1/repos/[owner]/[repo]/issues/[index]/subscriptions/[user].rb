# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/subscriptions/{user} -- scaffolded from the document.

# Subscribe user to issue
put "/" do
  # params: owner, repo, index, user
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

# Unsubscribe user from issue
delete "/" do
  # params: owner, repo, index, user
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(200)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/subscriptions/{user}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/subscriptions/{user}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true
    parameter name: :user, in: :path, schema: {"type" => "string"}, required: true

    put "Subscribe user to issue" do
      tags "issue"
      operationId "issueAddSubscription"
      response 200, "Already subscribed"
      response 201, "Successfully Subscribed"
      response 304, "User can only subscribe itself if he is no admin"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Unsubscribe user from issue" do
      tags "issue"
      operationId "issueDeleteSubscription"
      response 200, "Already unsubscribed"
      response 201, "Successfully Unsubscribed"
      response 304, "User can only subscribe itself if he is no admin"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "PUT /api/v1/repos/{owner}/{repo}/issues/{index}/subscriptions/{user} answers 200" do
    assert_api_response :put, 200, path_params: {owner: "owner", repo: "repo", index: 0, user: "user"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/subscriptions/{user} answers 200" do
    assert_api_response :delete, 200, path_params: {owner: "owner", repo: "repo", index: 0, user: "user"}
  end
end
