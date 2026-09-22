# frozen_string_literal: true

# WikiCommitList -- generated from models.json.
Factory.define(:wiki_commit_list, relation: :wiki_commit_list) do |f|
  f.sequence(:pageName) { |n| "pageName-#{n}" }
  f.commits { "[{\"author\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"commiter\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"message\":\"\",\"sha\":\"\"}]" }
  f.count { 0 }
end
