# frozen_string_literal: true
# /admin/cron/{task} -- scaffolded from the document.

# Run cron task
post "/" do
  # params: task
  # TODO: the guts -- no relation answers this one.
  content_type(:json)
  status(204)
  {}.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/admin/cron/{task}", type: :openapi do
  openapi_schema :public_api

  api_path "/admin/cron/{task}" do
    parameter name: :task, in: :path, schema: {"type" => "string"}, required: true

    post "Run cron task" do
      tags "admin"
      operationId "adminCronRun"
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/admin/cron/{task} answers 204" do
    assert_api_response :post, 204, path_params: {task: "task"}
  end
end
