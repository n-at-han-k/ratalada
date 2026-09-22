# frozen_string_literal: true
# /teams/{id} -- scaffolded from the document.

# Delete a team
delete "/" do
  records = relations[:team].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Edit a team
patch "/" do
  content_type(:json)
  records = relations[:team].where(:id => params["id"].to_i)
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get a team
get "/" do
  content_type(:json)
  record = relations[:team].where(:id => params["id"].to_i).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/teams/{id}", type: :openapi do
  openapi_schema :public_api

  api_path "/teams/{id}" do
    parameter name: :id, in: :path, schema: {"type" => "integer", "format" => "int64"}, required: true

    get "Get a team" do
      tags "organization"
      operationId "orgGetTeam"
      response 200, "Team" do
        schema(Schemas::Team)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a team" do
      tags "organization"
      operationId "orgDeleteTeam"
      response 204, "team deleted"
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Edit a team" do
      tags "organization"
      operationId "orgEditTeam"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditTeamOption}},
      )
      response 200, "Team" do
        schema(Schemas::Team)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end
  end

  it "GET /api/v1/teams/{id} answers 200" do
    Factory[:team, :id => 1]
    assert_api_response :get, 200, path_params: {id: 1}
  end

  it "DELETE /api/v1/teams/{id} answers 204" do
    Factory[:team, :id => 1]
    assert_api_response :delete, 204, path_params: {id: 1}
  end

  it "PATCH /api/v1/teams/{id} answers 200" do
    Factory[:team, :id => 1]
    assert_api_response :patch, 200, path_params: {id: 1}, body: {
      "can_create_org_repo" => false,
      "description" => "",
      "includes_all_repositories" => false,
      "name" => "",
      "permission" => "read",
      "units" => [""],
      "units_map" => {},
    }
  end
end
