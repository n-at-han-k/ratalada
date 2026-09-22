# frozen_string_literal: true
# /user/actions/runners/{runner_id} -- scaffolded from the document.

# Delete a particular user-level runner
delete "/" do
  records = relations[:action_runner].where(:runner_id => params["runner_id"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Get a particular runner that belongs to the user
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
RSpec.describe "/user/actions/runners/{runner_id}", type: :openapi do
  openapi_schema :public_api

  api_path "/user/actions/runners/{runner_id}" do
    parameter name: :runner_id, in: :path, schema: {"type" => "string"}, required: true

    get "Get a particular runner that belongs to the user" do
      tags "user"
      operationId "getUserRunner"
      response 200, "ActionRunner represents a runner" do
        schema(Schemas::ActionRunner)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a particular user-level runner" do
      tags "user"
      operationId "deleteUserRunner"
      response 204, "runner has been deleted"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/user/actions/runners/{runner_id} answers 200" do
    Factory[:action_runner, :runner_id => "runner_id"]
    assert_api_response :get, 200, path_params: {runner_id: "runner_id"}
  end

  it "DELETE /api/v1/user/actions/runners/{runner_id} answers 204" do
    Factory[:action_runner, :runner_id => "runner_id"]
    assert_api_response :delete, 204, path_params: {runner_id: "runner_id"}
  end
end
