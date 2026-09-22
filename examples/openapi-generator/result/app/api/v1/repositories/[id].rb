# frozen_string_literal: true
# /repositories/{id} -- scaffolded from the document.

# Get a repository by id
get "/" do
  content_type(:json)
  record = relations[:repository].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repositories/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/repositories/{id}" do
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a repository by id" do
      tags "repository"
      operationId "repoGetByID"
      response 200, "Repository" do
        schema(Schemas::Repository)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/repositories/{id} answers 200" do
    Factory[:repository, :id => 1]
    assert_api_response :get, 200, path_params: {id: 1}
  end
end
