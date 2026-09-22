# frozen_string_literal: true

# GitHook -- generated from models.json.
Factory.define(:git_hook, relation: :git_hook) do |f|
  f.sequence(:id) { |n| n }
  f.content { "" }
  f.is_active { false }
  f.name { "" }
end
