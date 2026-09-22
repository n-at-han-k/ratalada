# frozen_string_literal: true
# /admin/runners/jobs -- scaffolded from the document.

# Search action jobs according to filter conditions
get "/" do
  content_type(:json)
  status(200)
  relations[:action_run_job].to_a.map(&:to_h).to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/runners/jobs", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/runners/jobs" do

    get "Search action jobs according to filter conditions" do
      tags "admin"
      operationId "adminSearchRunJobs"
      parameter name: :labels, in: :query, schema: {"type" => "string"}, required: false
      response 200, "RunJobList is a list of action run jobs" do
        schema({
  "type" => "array",
  "items" => Schemas::ActionRunJob,
})
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
    end
  end

  it "GET /api/v1/admin/runners/jobs answers 200" do
    Factory[:action_run_job]
    assert_api_response :get, 200
  end
end
