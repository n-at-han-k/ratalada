# frozen_string_literal: true
# /repos/{owner}/{repo}/issues/{index}/reactions -- scaffolded from the document.

# Remove a reaction from an issue
delete "/" do
  records = relations[:reaction]
  not_found! if records.count.zero?
  records.command(:delete).call
  status(200)
  ""
end

# Get a list reactions of an issue
get "/" do
  content_type(:json)
  status(200)
  relations[:reaction].to_a.map(&:to_h).to_json
end

# Add a reaction to an issue
post "/" do
  content_type(:json)
  records = relations[:reaction]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/issues/{index}/reactions", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/issues/{index}/reactions" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :index, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a list reactions of an issue" do
      tags "issue"
      operationId "issueGetIssueReactions"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "ReactionList" do
        schema({
  "type" => "array",
  "items" => Schemas::Reaction,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Add a reaction to an issue" do
      tags "issue"
      operationId "issuePostIssueReaction"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditReactionOption}},
      )
      response 200, "Reaction" do
        schema(Schemas::Reaction)
      end
      response 201, "Reaction" do
        schema(Schemas::Reaction)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Remove a reaction from an issue" do
      tags "issue"
      operationId "issueDeleteIssueReaction"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditReactionOption}},
      )
      response 200, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/issues/{index}/reactions answers 200" do
    Factory[:reaction]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", index: 0}
  end

  it "POST /api/v1/repos/{owner}/{repo}/issues/{index}/reactions answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"content" => ""}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/issues/{index}/reactions answers 200" do
    Factory[:reaction]
    assert_api_response :delete, 200, path_params: {owner: "owner", repo: "repo", index: 0}, body: {"content" => ""}
  end
end
