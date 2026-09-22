# frozen_string_literal: true

# ActionVariable -- generated from models.json.
Factory.define(:action_variable, relation: :action_variable) do |f|
  f.sequence(:variablename) { |n| "variablename-#{n}" }
  f.data { "" }
  f.name { "" }
  f.owner_id { 0 }
  f.repo_id { 0 }
end
