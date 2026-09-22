# frozen_string_literal: true
# /packages/{owner} -- scaffolded from the document.

# Gets all packages of an owner
get "/" do
  content_type(:json)
  status(200)
  relations[:package].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/packages/{owner}", type: :openapi do
  openapi_schema :public_api

  api_path "/packages/{owner}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true

    get "Gets all packages of an owner" do
      tags "package"
      operationId "listPackages"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :type, in: :query, schema: {
  "type" => "string",
  "enum" => [
    "alpine",
    "cargo",
    "chef",
    "composer",
    "conan",
    "conda",
    "container",
    "cran",
    "debian",
    "generic",
    "go",
    "helm",
    "maven",
    "npm",
    "nuget",
    "pub",
    "pypi",
    "rpm",
    "rubygems",
    "swift",
    "vagrant",
  ],
}, required: false
      parameter name: :q, in: :query, schema: {"type" => "string"}, required: false
      response 200, "PackageList" do
        schema({
  "type" => "array",
  "items" => Schemas::Package,
})
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/packages/{owner} answers 200" do
    Factory[:package]
    assert_api_response :get, 200, path_params: {owner: "owner"}
  end
end
