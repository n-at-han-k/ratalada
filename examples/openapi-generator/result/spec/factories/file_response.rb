# frozen_string_literal: true

# FileResponse -- generated from models.json.
Factory.define(:file_response, relation: :file_response) do |f|
  f.sequence(:filepath) { |n| "filepath-#{n}" }
  f.commit { "{\"author\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"committer\":{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"},\"created\":\"2026-01-01T00:00:00Z\",\"html_url\":\"\",\"message\":\"\",\"parents\":[{\"created\":\"2026-01-01T00:00:00Z\",\"sha\":\"\",\"url\":\"\"}],\"sha\":\"\",\"tree\":{\"created\":\"2026-01-01T00:00:00Z\",\"sha\":\"\",\"url\":\"\"},\"url\":\"\"}" }
  f.content { "{\"_links\":{\"git\":\"\",\"html\":\"\",\"self\":\"\"},\"content\":\"\",\"download_url\":\"\",\"encoding\":\"\",\"git_url\":\"\",\"html_url\":\"\",\"last_commit_sha\":\"\",\"last_commit_when\":\"2026-01-01T00:00:00Z\",\"name\":\"\",\"path\":\"\",\"sha\":\"\",\"size\":0,\"submodule_git_url\":\"\",\"target\":\"\",\"type\":\"\",\"url\":\"\"}" }
  f.verification { "{\"payload\":\"\",\"reason\":\"\",\"signature\":\"\",\"signer\":{\"email\":\"someone@example.com\",\"name\":\"\",\"username\":\"\"},\"verified\":false}" }
end
