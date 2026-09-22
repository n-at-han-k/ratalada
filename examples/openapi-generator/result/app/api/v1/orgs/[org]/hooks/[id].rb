# frozen_string_literal: true
# /orgs/{org}/hooks/{id} -- scaffolded from the document.

# Delete a hook
delete "/" do
  records = relations[:hook].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Update a hook
patch "/" do
  content_type(:json)
  records = relations[:hook].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get a hook
get "/" do
  content_type(:json)
  record = relations[:hook].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/hooks/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/hooks/{id}" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a hook" do
      tags "organization"
      operationId "orgGetHook"
      response 200, "Hook" do
        schema(Schemas::Hook)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a hook" do
      tags "organization"
      operationId "orgDeleteHook"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Update a hook" do
      tags "organization"
      operationId "orgEditHook"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditHookOption}},
      )
      response 200, "Hook" do
        schema(Schemas::Hook)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/hooks/{id} answers 200" do
    Factory[:hook, :id => 1]
    assert_api_response :get, 200, path_params: {org: "org", id: 1}
  end

  it "DELETE /api/v1/orgs/{org}/hooks/{id} answers 204" do
    Factory[:hook, :id => 1]
    assert_api_response :delete, 204, path_params: {org: "org", id: 1}
  end

  it "PATCH /api/v1/orgs/{org}/hooks/{id} answers 200" do
    Factory[:hook, :id => 1]
    assert_api_response :patch, 200, path_params: {org: "org", id: 1}, body: {
      "active" => false,
      "authorization_header" => "",
      "branch_filter" => "",
      "config" => {},
      "events" => [""],
    }
  end
end
