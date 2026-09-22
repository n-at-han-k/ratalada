# frozen_string_literal: true

# WikiPage -- generated from models.json.
Factory.define(:wiki_page, relation: :wiki_page) do |f|
  f.sequence(:pageName) { |n| "pageName-#{n}" }
  f.commit_count { 0 }
  f.content_base64 { "" }
  f.footer { "" }
  f.html_url { "" }
  f.last_commit { "{\"author\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"commiter\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"message\":\"\",\"sha\":\"\"}" }
  f.sidebar { "" }
  f.sub_url { "" }
  f.title { "" }
end
