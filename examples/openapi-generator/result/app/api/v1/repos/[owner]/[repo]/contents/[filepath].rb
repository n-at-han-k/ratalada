# frozen_string_literal: true
# /repos/{owner}/{repo}/contents/{filepath} -- scaffolded from the document.

# Create a file in a repository
post "/" do
  content_type(:json)
  records = relations[:file_response]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# Delete a file in a repository
delete "/" do
  records = relations[:file_delete_response].where(:filepath => params["filepath"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(200)
  ""
end

# Gets the metadata and contents (if a file) of an entry in a repository, or a list of entries if a dir
get "/" do
  content_type(:json)
  record = relations[:contents_response].where(:filepath => params["filepath"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Update a file in a repository
put "/" do
  content_type(:json)
  records = relations[:file_response].where(:filepath => params["filepath"])
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
RSpec.describe "/repos/{owner}/{repo}/contents/{filepath}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/contents/{filepath}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :filepath, in: :path, schema: {"type" => "string"}, required: true

    get "Gets the metadata and contents (if a file) of an entry in a repository, or a list of entries if a dir" do
      tags "repository"
      operationId "repoGetContents"
      parameter name: :ref, in: :query, schema: {"type" => "string"}, required: false
      response 200, "ContentsResponse" do
        schema(Schemas::ContentsResponse)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Update a file in a repository" do
      tags "repository"
      operationId "repoUpdateFile"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::UpdateFileOptions}},
      )
      response 200, "FileResponse" do
        schema(Schemas::FileResponse)
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

    post "Create a file in a repository" do
      tags "repository"
      operationId "repoCreateFile"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::CreateFileOptions}},
      )
      response 201, "FileResponse" do
        schema(Schemas::FileResponse)
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

    delete "Delete a file in a repository" do
      tags "repository"
      operationId "repoDeleteFile"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::DeleteFileOptions}},
      )
      response 200, "FileDeleteResponse" do
        schema(Schemas::FileDeleteResponse)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 403, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 413, "QuotaExceeded"
      response 423, "APIRepoArchivedError is an error that is raised when an archived repo should be modified" do
        schema(Schemas::APIRepoArchivedError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo}/contents/{filepath} answers 200" do
    Factory[:contents_response, :filepath => "filepath"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo", filepath: "filepath"}
  end

  it "PUT /api/v1/repos/{owner}/{repo}/contents/{filepath} answers 200" do
    Factory[:file_response, :filepath => "filepath"]
    assert_api_response :put, 200, path_params: {owner: "owner", repo: "repo", filepath: "filepath"}, body: {
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

  it "POST /api/v1/repos/{owner}/{repo}/contents/{filepath} answers 201" do
    assert_api_response :post, 201, path_params: {owner: "owner", repo: "repo", filepath: "filepath"}, body: {
      "author" => {"email" => "someone@example.com", "name" => ""},
      "branch" => "",
      "committer" => {"email" => "someone@example.com", "name" => ""},
      "content" => "",
      "dates" => {
        "author" => "2026-01-01T00:00:00Z",
        "committer" => "2026-01-01T00:00:00Z",
      },
      "force_overwrite_new_branch" => false,
      "message" => "",
      "new_branch" => "",
      "signoff" => false,
    }
  end

  it "DELETE /api/v1/repos/{owner}/{repo}/contents/{filepath} answers 200" do
    Factory[:file_delete_response, :filepath => "filepath"]
    assert_api_response :delete, 200, path_params: {owner: "owner", repo: "repo", filepath: "filepath"}, body: {
      "author" => {"email" => "someone@example.com", "name" => ""},
      "branch" => "",
      "committer" => {"email" => "someone@example.com", "name" => ""},
      "dates" => {
        "author" => "2026-01-01T00:00:00Z",
        "committer" => "2026-01-01T00:00:00Z",
      },
      "force_overwrite_new_branch" => false,
      "message" => "",
      "new_branch" => "",
      "sha" => "",
      "signoff" => false,
    }
  end
end
