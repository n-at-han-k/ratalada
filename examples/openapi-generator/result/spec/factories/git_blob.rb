# frozen_string_literal: true

# GitBlob -- generated from models.json.
Factory.define(:git_blob, relation: :git_blob) do |f|
  f.sequence(:sha) { |n| "sha-#{n}" }
  f.content { "" }
  f.encoding { "" }
  f.size { 0 }
  f.url { "" }
end
