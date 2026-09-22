# frozen_string_literal: true
# /repos/{owner}/{repo}/sync_fork -- scaffolded from the document.

# Syncs the default branch of a fork with the base branch
post "/" do
  content_type(:json)
  records = relations[:sync_fork_info]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(204)
  record.to_h.to_json
end

# Gets information about syncing the fork default branch with the base branch
get "/" do
  content_type(:json)
  record = relations[:sync_fork_info].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/sync_fork", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/sync_fork" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Gets information about syncing the fork default branch with the base branch" do
      tags "repository"
      operationId "repoSyncForkDefaultInfo"
      response 200, "SyncForkInfo" do
        schema(Schemas::SyncForkInfo)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Syncs the default branch of a fork with the base branch" do
      tags "repository"
      operationId "repoSyncForkDefault"
      response 204, "APIEmpty is an empty response"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/sync_fork answers 200" do
    Factory[:sync_fork_info]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/sync_fork answers 204" do
    assert_api_response :post, 204, path_params: {owner: "owner", repo: "repo"}
  end
end
