# frozen_string_literal: true

# ContentsResponse -- generated from models.json.
Factory.define(:contents_response, relation: :contents_response) do |f|
  f.sequence(:filepath) { |n| "filepath-#{n}" }
  f._links { "{\"git\":\"\",\"html\":\"\",\"self\":\"\"}" }
  f.content { "" }
  f.download_url { "" }
  f.encoding { "" }
  f.git_url { "" }
  f.html_url { "" }
  f.last_commit_sha { "" }
  f.last_commit_when { "2026-01-01T00:00:00Z" }
  f.name { "" }
  f.path { "" }
  f.sha { "" }
  f.size { 0 }
  f.submodule_git_url { "" }
  f.target { "" }
  f.type { "" }
  f.url { "" }
end
