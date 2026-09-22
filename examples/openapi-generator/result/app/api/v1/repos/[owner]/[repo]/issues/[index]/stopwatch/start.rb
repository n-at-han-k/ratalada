# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/stopwatch/start -- scaffolded from the document.

# Start stopwatch on an issue.
post "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/stopwatch/start", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/stopwatch/start" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    post "Start stopwatch on an issue." do
      tags "issue"
      operationId "issueStartStopWatch"
      response 201, "APIEmpty is an empty response"
      response 403, "Not repo writer, user does not have rights to toggle stopwatch"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "Cannot start a stopwatch again if it already exists"
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues/{index}/stopwatch/start answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
