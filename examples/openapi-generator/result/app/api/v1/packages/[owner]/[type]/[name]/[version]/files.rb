# frozen_string_literal: true
# /packages/{owner}/{type}/{name}/{version}/files -- scaffolded from the document.

# Gets all files of a package
get "/" do
  content_type(:json)
  status(200)
  relations[:package_file].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/packages/{owner}/{type}/{name}/{version}/files", type: :openapi do
  openapi_schema :public_api

  api_path "/packages/{owner}/{type}/{name}/{version}/files" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :type, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :name, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :version, in: :path, schema: {"type" => "string"}, required: true

    get "Gets all files of a package" do
      tags "package"
      operationId "listPackageFiles"
      response 200, "PackageFileList" do
        schema({
  "type" => "array",
  "items" => Schemas::PackageFile,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/packages/{owner}/{type}/{name}/{version}/files answers 200" do
    Factory[:package_file]
    assert_api_response :get, 200, path_params: {
      :owner => "owner",
      :type => "type",
      :name => "name",
      :version => "version",
    }
  end
end
