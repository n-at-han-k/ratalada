# frozen_string_literal: true
# /repos/{owner}/{repo} -- scaffolded from the document.

# Delete a repository
delete "/" do
  records = relations[:repository].where(:repo => params["repo"])
  not_found! if records.count.zero?
  records.command(:delete).call
  status(204)
  ""
end

# Edit a repository's properties. Only fields that are set will be changed.
patch "/" do
  content_type(:json)
  records = relations[:repository].where(:repo => params["repo"])
  not_found! if records.count.zero?
  attributes = accepted(records, parsed_body)
  # Nothing the relation knows about: an UPDATE with no SET is not SQL.
  record = attributes.empty? ? records.first : records.command(:update).call(attributes)
  # One row updated comes back as the struct itself, several as a list.
  record = record.first if record.is_a?(Array)
  status(200)
  record.to_h.to_json
end

# Get a repository
get "/" do
  content_type(:json)
  record = relations[:repository].where(:repo => params["repo"]).first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/repos/{owner}/{repo}", type: :openapi do
  openapi_schema :public_api

  api_path "/repos/{owner}/{repo}" do
    parameter name: :owner, in: :path, schema: {"type" => "string"}, required: true
    parameter name: :repo, in: :path, schema: {"type" => "string"}, required: true

    get "Get a repository" do
      tags "repository"
      operationId "repoGet"
      response 200, "Repository" do
        schema(Schemas::Repository)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    delete "Delete a repository" do
      tags "repository"
      operationId "repoDelete"
      response 204, "APIEmpty is an empty response"
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
    end

    patch "Edit a repository's properties. Only fields that are set will be changed." do
      tags "repository"
      operationId "repoEdit"
      request_body(
        required: false,
        content: {"application/json" => {schema: Schemas::EditRepoOption}},
      )
      response 200, "Repository" do
        schema(Schemas::Repository)
      end
      response 403, "APIForbiddenError is a forbidden error response" do
        schema(Schemas::APIForbiddenError)
      end
      response 404, "APINotFound is a not found error response" do
        schema(Schemas::APINotFound)
      end
      response 422, "APIValidationError is error format response related to input validation" do
        schema(Schemas::APIValidationError)
      end
    end
  end

  it "GET /api/v1/repos/{owner}/{repo} answers 200" do
    Factory[:repository, :repo => "repo"]
    assert_api_response :get, 200, path_params: {owner: "owner", repo: "repo"}
  end

  it "DELETE /api/v1/repos/{owner}/{repo} answers 204" do
    Factory[:repository, :repo => "repo"]
    assert_api_response :delete, 204, path_params: {owner: "owner", repo: "repo"}
  end

  it "PATCH /api/v1/repos/{owner}/{repo} answers 200" do
    Factory[:repository, :repo => "repo"]
    assert_api_response :patch, 200, path_params: {owner: "owner", repo: "repo"}, body: {
      "allow_fast_forward_only_merge" => false,
      "allow_manual_merge" => false,
      "allow_merge_commits" => false,
      "allow_rebase" => false,
      "allow_rebase_explicit" => false,
      "allow_rebase_update" => false,
      "allow_squash_merge" => false,
      "archived" => false,
      "autodetect_manual_merge" => false,
      "default_allow_maintainer_edit" => false,
      "default_branch" => "",
      "default_delete_branch_after_merge" => false,
      "default_merge_style" => "",
      "default_update_style" => "",
      "description" => "",
      "enable_prune" => false,
      "external_tracker" => {
        "external_tracker_format" => "",
        "external_tracker_regexp_pattern" => "",
        "external_tracker_style" => "",
        "external_tracker_url" => "",
      },
      "external_wiki" => {"external_wiki_url" => ""},
      "globally_editable_wiki" => false,
      "has_actions" => false,
      "has_issues" => false,
      "has_packages" => false,
      "has_projects" => false,
      "has_pull_requests" => false,
      "has_releases" => false,
      "has_wiki" => false,
      "ignore_whitespace_conflicts" => false,
      "internal_tracker" => {
        "allow_only_contributors_to_track_time" => false,
        "enable_issue_dependencies" => false,
        "enable_time_tracker" => false,
      },
      "mirror_interval" => "",
      "name" => "",
      "private" => false,
      "template" => false,
      "website" => "",
      "wiki_branch" => "",
    }
  end
end
