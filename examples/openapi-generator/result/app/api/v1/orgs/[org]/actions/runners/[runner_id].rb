# frozen_string_literal: true
# /orgs/{org}/actions/runners/{runner_id} -- scaffolded from the document.

# Delete a particular runner that belongs to the organization
delete "/" do
  records = relations[:action_runner].where(:runner_id => params["runner_id"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get a particular runner that belongs to the organization
get "/" do
  content_type(:json)
  record = relations[:action_runner].where(:runner_id => params["runner_id"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/orgs/{org}/actions/runners/{runner_id}", type: :openapi do
  openapi_schema :public_api

  api_path "/orgs/{org}/actions/runners/{runner_id}" do
    parameter name: :org, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :runner_id, in: :path, schema: {"type" => "string"}, required: true

    get "Get a particular runner that belongs to the organization" do
      tags "organization"
      operationId "getOrgRunner"
      response 200, "ActionRunner represents a runner" do
        schema(Schemas::ActionRunner)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a particular runner that belongs to the organization" do
      tags "organization"
      operationId "deleteOrgRunner"
      response 204, "runner has been deleted"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/orgs/{org}/actions/runners/{runner_id} answers 200" do
    Factory[:action_runner, :runner_id => "runner_id"]
    assert_api_response :get, 200, path_params: {org: "org", runner_id: "runner_id"}
  end

  it "DELETE /api/v1/orgs/{org}/actions/runners/{runner_id} answers 204" do
    Factory[:action_runner, :runner_id => "runner_id"]
    assert_api_response :delete, 204, path_params: {org: "org", runner_id: "runner_id"}
  end
end
