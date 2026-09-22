# frozen_string_literal: true
# /repos/{owner}/{repo}/diffpatch -- scaffolded from the document.

# Apply diff patch to repository
post "/" do
  content_type(:json)
  records = relations[:file_response]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/diffpatch", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/diffpatch" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    post "Apply diff patch to repository" do
      tags "repository"
      operationId "repoApplyDiffPatch"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::UpdateFileOptions}},
      )
      response 200, "FileResponse" do
        schema(Schemas::FileResponse)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 413, "QuotaExceeded"
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/diffpatch answers 200" do
    assert_api_response :post, 200, path_params: {owner: "owner", repo: "repo"}, body: {
      "author" => {"email" => "someone@example.com", "name" => ""},
      "branch" => "",
      "committer" => {"email" => "someone@example.com", "name" => ""},
      "content" => "",
      "dates" => {
        "author" => "2026-01-01T00:00:00Z",
        "committer" => "2026-01-01T00:00:00Z",
      },
      "force_overwrite_new_branch" => false,
      "from_path" => "",
      "message" => "",
      "new_branch" => "",
      "sha" => "",
      "signoff" => false,
    }
  end
end
