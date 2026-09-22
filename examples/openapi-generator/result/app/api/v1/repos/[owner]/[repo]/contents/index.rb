# frozen_string_literal: true
# /repos/{owner}/{repo}/contents -- scaffolded from the document.

# Modify multiple files in a repository
post "/" do
  content_type(:json)
  records = relations[:files_response]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# Gets the metadata of all the entries of the root dir
get "/" do
  content_type(:json)
  status(200)
  relations[:contents_response].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/contents", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/contents" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Gets the metadata of all the entries of the root dir" do
      tags "repository"
      operationId "repoGetContentsList"
      parameter name: :ref, in: :query, schema: {"type" => "string"}, required: false
      response 200, "ContentsListResponse" do
        schema({
  "type" => "array",
  "items" => Schemas::ContentsResponse,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Modify multiple files in a repository" do
      tags "repository"
      operationId "repoChangeFiles"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::ChangeFilesOptions}},
      )
      response 201, "FilesResponse" do
        schema(Schemas::FilesResponse)
      end
      response 403, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 409, "APIConflict is a conflict empty response"
      response 413, "QuotaExceeded"
      response 422, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/contents answers 200" do
    Factory[:contents_response]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "POST /api/v1/repos/{owner}/{repo}/contents answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo"}, body: {
      "author" => {"email" => "someone@example.com", "name" => ""},
      "branch" => "",
      "committer" => {"email" => "someone@example.com", "name" => ""},
      "dates" => {
        "author" => "2026-01-01T00:00:00Z",
        "committer" => "2026-01-01T00:00:00Z",
      },
      "files" => [
        {
          "content" => "",
          "from_path" => "",
          "operation" => "create",
          "path" => "",
          "sha" => "",
        },
      ],
      "force_overwrite_new_branch" => false,
      "message" => "",
      "new_branch" => "",
      "signoff" => false,
    }
  end
end
