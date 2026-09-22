# frozen_string_literal: true
# /user/emails -- scaffolded from the document.

# Add an email addresses to the current user's account
post "/" do
  content_type(:json)
  records = relations[:email]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# Delete email addresses from the current user's account
delete "/" do
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

# List all email addresses of the current user
get "/" do
  content_type(:json)
  status(200)
  relations[:email].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/user/emails", type: :openapi do
  openapi_schema :public_api

  api_path "/user/emails" do

    get "List all email addresses of the current user" do
      tags "user"
      operationId "userListEmails"
      response 200, "EmailList" do
        schema({
  "type" => "array",
  "items" => Schemas::Email,
})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end

    post "Add an email addresses to the current user's account" do
      tags "user"
      operationId "userAddEmail"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::CreateEmailOption}},
      )
      response 201, "EmailList" do
        schema({
  "type" => "array",
  "items" => Schemas::Email,
})
      end
      response 401, "APIUnauthorizedError is a unauthorized error response" do
        schema(Schemas::APIUnauthorizedError)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end

    delete "Delete email addresses from the current user's account" do
      tags "user"
      operationId "userDeleteEmail"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::DeleteEmailOption}},
      )
      response 204, "APIEmpty is an empty response"
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

  it "GET /api/v1/user/emails answers 200" do
    Factory[:email]
    assert_api_response :get, 200
  end

  it "POST /api/v1/user/emails answers 201" do
    assert_api_response :post, 201, body: {"emails" => [""]}
  end

  it "DELETE /api/v1/user/emails answers 204" do
    assert_api_response :delete, 204, body: {"emails" => [""]}
  end
end
