# frozen_string_literal: true
# /user/actions/variables/{variablename} -- scaffolded from the document.

# Create a user-level variable
post "/" do
  content_type(:json)
  records = relations[:action_variable]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# Delete a user-level variable which is created by current doer
delete "/" do
  records = relations[:action_variable].where(:variablename => params["variablename"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(201)
  ""
end

# Get a user-level variable which is created by current doer
get "/" do
  content_type(:json)
  record = relations[:action_variable].where(:variablename => params["variablename"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

# Update a user-level variable which is created by current doer
put "/" do
  content_type(:json)
  records = relations[:action_variable].where(:variablename => params["variablename"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/actions/variables/{variablename}", type: :openapi do
  openapi_schema :public_api

  api_path "/user/actions/variables/{variablename}" do
    parameter name: :variablename, in: :path, schema: {"type" => "string"}, required: true

    get "Get a user-level variable which is created by current doer" do
      tags "user"
      operationId "getUserVariable"
      response 200, "ActionVariable" do
        schema(Schemas::ActionVariable)
      end
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    put "Update a user-level variable which is created by current doer" do
      tags "user"
      operationId "updateUserVariable"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::UpdateVariableOption}},
      )
      response 201, "response when updating a variable"
      response 204, "response when updating a variable"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    post "Create a user-level variable" do
      tags "user"
      operationId "createUserVariable"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateVariableOption}},
      )
      response 201, "response when creating a variable"
      response 204, "response when creating a variable"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a user-level variable which is created by current doer" do
      tags "user"
      operationId "deleteUserVariable"
      response 201, "response when deleting a variable"
      response 204, "response when deleting a variable"
      response 400, "APIError is error format response" do
        schema(Schemas::APIError)
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/user/actions/variables/{variablename} answers 200" do
    Factory[:action_variable, :variablename => "variablename"]
    assert_api_response :get, 200, path_params: {variablename: "variablename"}
  end

  it "PUT /api/v1/user/actions/variables/{variablename} answers 201" do
    Factory[:action_variable, :variablename => "variablename"]
    assert_api_response :put, 201, path_params: {variablename: "variablename"}, body: {"name" => "", "value" => ""}
  end

  it "POST /api/v1/user/actions/variables/{variablename} answers 201" do
    assert_api_response :post, 201, path_params: {variablename: "variablename"}, body: {"value" => ""}
  end

  it "DELETE /api/v1/user/actions/variables/{variablename} answers 201" do
    Factory[:action_variable, :variablename => "variablename"]
    assert_api_response :delete, 201, path_params: {variablename: "variablename"}
  end
end
