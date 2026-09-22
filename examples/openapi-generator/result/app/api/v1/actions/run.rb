# frozen_string_literal: true
# /actions/run -- scaffolded from the document.

# Get a workflow run associated with a token
get "/" do
  content_type(:json)
  record = relations[:action_run].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/actions/run", type: :openapi do
  openapi_schema :public_api

  api_path "/actions/run" do

    get "Get a workflow run associated with a token" do
      tags "miscellaneous"
      operationId "getActionsRun"
      response 200, "ActionRun" do
        schema(Schemas::ActionRun)
      end
    end
  end

  it "GET /api/v1/actions/run answers 200" do
    Factory[:action_run]
    assert_api_response :get, 200
  end
end
