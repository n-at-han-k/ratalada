# frozen_string_literal: true

# FileDeleteResponse -- generated from models.json.
Factory.define(:file_delete_response, relation: :file_delete_response) do |f|
  f.sequence(:filepath) { |n| "filepath-#{n}" }
  f.commit { "{\"author\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"committer\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"created\":\"2026-01-01T00:00:00Z\",\"html_url\":\"\",\"message\":\"\",\"parents\":[{\"created\":\"2026-01-01T00:00:00Z\",\"sha\":\"\",\"url\":\"\"}],\"sha\":\"\",\"tree\":{\"created\":\"2026-01-01T00:00:00Z\",\"sha\":\"\",\"url\":\"\"},\"url\":\"\"}" }
  f.content { "{}" }
  f.verification { "{\"payload\":\"\",\"reason\":\"\",\"signature\":\"\",\"signer\":{\"email\":\"someone@example.com\",\"name\":\"\",\"username\":\"\"},\"verified\":false}" }
end
