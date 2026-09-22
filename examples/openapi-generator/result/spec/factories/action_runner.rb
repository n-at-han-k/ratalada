# frozen_string_literal: true

# ActionRunner -- generated from models.json.
Factory.define(:action_runner, relation: :action_runner) do |f|
  f.sequence(:runner_id) { |n| "runner_id-#{n}" }
  f.description { "" }
  f.ephemeral { false }
  f.labels { "[\"\"]" }
  f.name { "" }
  f.owner_id { 0 }
  f.repo_id { 0 }
  f.status { "offline" }
  f.uuid { "" }
  f.version { "" }
end
