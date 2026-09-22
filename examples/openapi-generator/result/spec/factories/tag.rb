# frozen_string_literal: true

# Tag -- generated from models.json.
Factory.define(:tag, relation: :tag) do |f|
  f.sequence(:tag) { |n| "tag-#{n}" }
  f.archive_download_count { "{\"tar_gz\":0,\"zip\":0}" }
  f.commit { "{\"created\":\"2026-01-01T00:00:00Z\",\"sha\":\"\",\"url\":\"\"}" }
  f.message { "" }
  f.name { "" }
  f.tarball_url { "" }
  f.zipball_url { "" }
end
