# frozen_string_literal: true
# /settings/repository -- scaffolded from the document.

# Get instance's global settings for repositories
get "/" do
  content_type(:json)
  record = relations[:general_repo_settings].first
  not_found! if record.nil?
  status(200)
  record.to_h.to_json
end

__END__

# Scaffolded from forgejo.json. One api_path per page, which is
# what keeps `assert_api_response` unambiguous on sibling paths.
RSpec.describe "/settings/repository", type: :openapi do
  openapi_schema :public_api

  api_path "/settings/repository" do

    get "Get instance's global settings for repositories" do
      tags "settings"
      operationId "getGeneralRepositorySettings"
      response 200, "GeneralRepoSettings" do
        schema(Schemas::GeneralRepoSettings)
      end
    end
  end

  it "GET /api/v1/settings/repository answers 200" do
    Factory[:general_repo_setting]
    assert_api_response :get, 200
  end
end
