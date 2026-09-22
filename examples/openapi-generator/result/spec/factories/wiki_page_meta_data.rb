# frozen_string_literal: true

# WikiPageMetaData -- generated from models.json.
Factory.define(:wiki_page_meta_datum, relation: :wiki_page_meta_data) do |f|
  f.html_url { "" }
  f.last_commit { "{\"author\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"commiter\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"message\":\"\",\"sha\":\"\"}" }
  f.sub_url { "" }
  f.title { "" }
end
