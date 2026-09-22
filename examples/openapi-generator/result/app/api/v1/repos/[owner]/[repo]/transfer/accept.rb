# frozen_string_literal: true
# /repos/{owner}/{repo}/transfer/accept -- scaffolded from the document.

# Accept a repo transfer
post "/" do
  content_type(:json)
  records = relations[:repository]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(202)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/transfer/accept", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/transfer/accept" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    post "Accept a repo transfer" do
      tags "repository"
      operationId "acceptRepoTransfer"
      response 202, "Repository" do
        schema(Schemas::Repository)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 413, "QuotaExceeded"
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/transfer/accept answers 202" do
    assert_api_response :post, 202, path_params: {owner: "owner", repo: "repo"}
  end
end
