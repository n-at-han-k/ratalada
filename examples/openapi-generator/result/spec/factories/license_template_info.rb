# frozen_string_literal: true

# LicenseTemplateInfo -- generated from models.json.
Factory.define(:license_template_info, relation: :license_template_info) do |f|
  f.sequence(:name) { |n| "name-#{n}" }
  f.body { "" }
  f.implementation { "" }
  f.key { "" }
  f.url { "" }
end
