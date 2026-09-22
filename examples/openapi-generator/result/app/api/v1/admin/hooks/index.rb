# frozen_string_literal: true
# /admin/hooks -- scaffolded from the document.

# Create a hook
post "/" do
  content_type(:json)
  records = relations[:hook]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

# List global (system) webhooks
get "/" do
  content_type(:json)
  status(200)
  relations[:hook].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/hooks", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/hooks" do

    get "List global (system) webhooks" do
      tags "admin"
      operationId "adminListHooks"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "HookListWithoutPagination - Hooks without pagination headers" do
        schema({
  "type" => "array",
  "items" => Schemas::Hook,
})
      end
    end

    post "Create a hook" do
      tags "admin"
      operationId "adminCreateHook"
      request_body(
        required: true,
        content: {"application/json" => {schema: Schemas::CreateHookOption}},
      )
      response 201, "Hook" do
        schema(Schemas::Hook)
      end
    end
  end

  it "GET /api/v1/admin/hooks answers 200" do
    Factory[:hook]
    assert_api_response :get, 200
  end

  it "POST /api/v1/admin/hooks answers 201" do
    assert_api_response :post, 201, body: {
      "active" => false,
      "authorization_header" => "",
      "branch_filter" => "",
      "config" => {},
      "events" => [""],
      "type" => "forgejo",
    }
  end
end
