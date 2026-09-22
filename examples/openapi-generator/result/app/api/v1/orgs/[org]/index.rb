# frozen_string_literal: true
# /orgs/{org} -- scaffolded from the document.

# Delete an organization
delete "/" do
  records = relations[:organization].where(:org => params["org"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Edit an organization
patch "/" do
  content_type(:json)
  records = relations[:organization].where(:org => params["org"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get an organization
get "/" do
  content_type(:json)
  record = relations[:organization].where(:org => params["org"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true

    get "Get an organization" do
      tags "organization"
      operationId "orgGet"
      response 200, "Organization" do
        schema(Schemas::Organization)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete an organization" do
      tags "organization"
      operationId "orgDelete"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Edit an organization" do
      tags "organization"
      operationId "orgEdit"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::EditOrgOption}},
      )
      response 200, "Organization" do
        schema(Schemas::Organization)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIError is error format response" do
        schema(Schemas::APIError)
      end
    end
  end

  it "GET /api/v1/orgs/{org} answers 200" do
    Factory[:organization, :org => "org"]
    assert_api_response :get, 200, path_params: {org: "org"}
  end

  it "DELETE /api/v1/orgs/{org} answers 204" do
    Factory[:organization, :org => "org"]
    assert_api_response :delete, 204, path_params: {org: "org"}
  end

  it "PATCH /api/v1/orgs/{org} answers 200" do
    Factory[:organization, :org => "org"]
    assert_api_response :patch, 200, path_params: {org: "org"}, body: {
      "description" => "",
      "email" => "",
      "full_name" => "",
      "location" => "",
      "repo_admin_change_team_access" => false,
      "visibility" => "public",
      "website" => "",
    }
  end
end
