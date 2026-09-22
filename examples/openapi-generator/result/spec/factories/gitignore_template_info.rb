# frozen_string_literal: true

# GitignoreTemplateInfo -- generated from models.json.
Factory.define(:gitignore_template_info, relation: :gitignore_template_info) do |f|
  f.sequence(:name) { |n| "name-#{n}" }
  f.source { "" }
end
