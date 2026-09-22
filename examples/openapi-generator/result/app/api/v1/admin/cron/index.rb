# frozen_string_literal: true
# /admin/cron -- scaffolded from the document.

# List cron tasks
get "/" do
  content_type(:json)
  status(200)
  relations[:cron].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/cron", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/cron" do

    get "List cron tasks" do
      tags "admin"
      operationId "adminCronList"
      parameter name: :page, in: :query, schema: {"type" => "integer"}, required: false
      parameter name: :limit, in: :query, schema: {"type" => "integer"}, required: false
      response 200, "CronList" do
        schema({
  "type" => "array",
  "items" => Schemas::Cron,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/admin/cron answers 200" do
    Factory[:cron]
    assert_api_response :get, 200
  end
end
