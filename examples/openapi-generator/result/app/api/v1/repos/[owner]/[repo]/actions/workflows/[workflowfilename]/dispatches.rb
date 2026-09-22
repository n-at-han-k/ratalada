# frozen_string_literal: true
# /repos/{owner}/{repo}/actions/workflows/{workflowfilename}/dispatches -- scaffolded from the document.

# Dispatches a workflow
post "/" do
  content_type(:json)
  records = relations[:dispatch_workflow_run]
  record = records.command(:create).call(accepted(records, parsed_body))
  status(201)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}/actions/workflows/{workflowfilename}/dispatches", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}/actions/workflows/{workflowfilename}/dispatches" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :workflowfilename, in: :path, schema: {"type" => "string"}, required: true

    post "Dispatches a workflow" do
      tags "repository"
      operationId "DispatchWorkflow"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::DispatchWorkflowOption}},
      )
      response 201, "DispatchWorkflowRun is a Workflow Run after dispatching" do
        schema(Schemas::DispatchWorkflowRun)
      end
      response 204, "APIEmpty is an empty response"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "POST /api/v1/repos/{owner}/{repo}/actions/workflows/{workflowfilename}/dispatches answers 201" do
    assert_api_response :post, 201, path_params: {
      :owner => "owner",
      :repo => "repo",
      :workflowfilename => "workflowfilename",
    }, body: {"inputs" => {}, "ref" => "", "return_run_info" => false}
  end
end
