# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/stopwatch/delete -- scaffolded from the document.

# Delete an issue's existing stopwatch.
delete "/" do
  # params: owner, repo, index
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/stopwatch/delete", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/stopwatch/delete" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    delete "Delete an issue's existing stopwatch." do
      tags "issue"
      operationId "issueDeleteStopWatch"
      response 204, "APIEmpty is an empty response"
      response 403, "Not repo writer, user does not have rights to toggle stopwatch"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "Cannot cancel a non existent stopwatch"
    end
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/stopwatch/delete answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo", index: 0}
  end
end
