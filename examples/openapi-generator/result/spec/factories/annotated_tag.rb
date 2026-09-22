# frozen_string_literal: true

# AnnotatedTag -- generated from models.json.
Factory.define(:annotated_tag, relation: :annotated_tag) do |f|
  f.sequence(:sha) { |n| "sha-#{n}" }
  f.archive_download_count { "{\"tar_gz\":0,\"zip\":0}" }
  f.message { "" }
  f.object { "{\"sha\":\"\",\"type\":\"\",\"url\":\"\"}" }
  f.tag { "" }
  f.tagger { "{\"date\":\"\",\"email\":\"someone@example.com\",\"name\":\"\"}" }
  f.url { "" }
  f.verification { "{\"payload\":\"\",\"reason\":\"\",\"signature\":\"\",\"signer\":{\"email\":\"someone@example.com\",\"name\":\"\",\"username\":\"\"},\"verified\":false}" }
end
