# frozen_string_literal: true
# /packages/{owner}/{type}/{name}/{version} -- scaffolded from the document.

# Delete a package
delete "/" do
  records = relations[:package].where(:version => params["version"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Gets a package
get "/" do
  content_type(:json)
  record = relations[:package].where(:version => params["version"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/packages/{owner}/{type}/{name}/{version}", type: :openapi do
  openapi_schema :public_api

  api_path "/packages/{owner}/{type}/{name}/{version}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :type, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :name, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :version, in: :path, schema: {"type" => "string"}, required: true

    get "Gets a package" do
      tags "package"
      operationId "getPackage"
      response 200, "Package" do
        schema(Schemas::Package)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a package" do
      tags "package"
      operationId "deletePackage"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/packages/{owner}/{type}/{name}/{version} answers 200" do
    Factory[:package, :version => "version"]
    assert_api_response :get, 200, path_params: {
      :owner => "owner",
      :type => "type",
      :name => "name",
      :version => "version",
    }
  end

  it "DELETE /api/v1/packages/{owner}/{type}/{name}/{version} answers 204" do
    Factory[:package, :version => "version"]
    assert_api_response :delete, 204, path_params: {
      :owner => "owner",
      :type => "type",
      :name => "name",
      :version => "version",
    }
  end
end
