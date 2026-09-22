# frozen_string_literal: true
# /repos/{owner}/{repo}/subscription -- scaffolded from the document.

# Check if the current user is watching a repo
get "/" do
  content_type(:json)
  record = relations[:watch_info].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Unwatch a repo
delete "/" do
  records = relations[:watch_info]
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Watch a repo
put "/" do
  content_type(:json)
  records = relations[:watch_info]
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/subscription", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/subscription" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Check if the current user is watching a repo" do
      tags "repository"
      operationId "userCurrentCheckSubscription"
      response 200, "WatchInfo" do
        schema(Schemas::WatchInfo)
      end
      response 404, "User is not watching this repo or repo do not exist"
    end

    put "Watch a repo" do
      tags "repository"
      operationId "userCurrentPutSubscription"
      response 200, "WatchInfo" do
        schema(Schemas::WatchInfo)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Unwatch a repo" do
      tags "repository"
      operationId "userCurrentDeleteSubscription"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/subscription answers 200" do
    Factory[:watch_info]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/subscription answers 200" do
    Factory[:watch_info]
    assert_api_response :put, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/subscription answers 204" do
    Factory[:watch_info]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo"}
  end
end
