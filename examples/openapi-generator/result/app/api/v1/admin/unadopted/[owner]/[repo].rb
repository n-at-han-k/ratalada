# frozen_string_literal: true
# /admin/unadopted/{owner}/{repo} -- scaffolded from the document.

# Adopt unadopted files as a repository
post "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# Delete unadopted files
delete "/" do
  # params: owner, repo
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/unadopted/{owner}/{repo}", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/unadopted/{owner}/{repo}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    post "Adopt unadopted files as a repository" do
      tags "admin"
      operationId "adminAdoptRepository"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete unadopted files" do
      tags "admin"
      operationId "adminDeleteUnadoptedRepository"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "POST /api/v1/admin/unadopted/{owner}/{repo} answers 204" do
    assert_api_response :post, 204, path_params: {owner: "owner", repo: "repo"}
  end

  it "DELETE /api/v1/admin/unadopted/{owner}/{repo} answers 204" do
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo"}
  end
end
