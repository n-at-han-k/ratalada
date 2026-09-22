# frozen_string_literal: true
# /packages/{owner}/{type}/{name}/-/link/{repo_name} -- scaffolded from the document.

# Link a package to a repository
post "/" do
  # params: owner, type, name, repo_name
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(201)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/packages/{owner}/{type}/{name}/-/link/{repo_name}", type: :openapi do
  openapi_schema :public_api

  api_path "/packages/{owner}/{type}/{name}/-/link/{repo_name}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :type, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :name, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo_name, in: :path, schema: {"type" => "string"}, required: true

    post "Link a package to a repository" do
      tags "package"
      operationId "linkPackage"
      response 201, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/packages/{owner}/{type}/{name}/-/link/{repo_name} answers 201" do
    assert_api_response :post, 201, path_params: {
      :owner => "owner",
      :type => "type",
      :name => "name",
      :repo_name => "repo_name",
    }
  end
end
