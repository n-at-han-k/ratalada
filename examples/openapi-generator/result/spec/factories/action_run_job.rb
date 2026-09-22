# frozen_string_literal: true

# ActionRunJob -- generated from models.json.
Factory.define(:action_run_job, relation: :action_run_job) do |f|
  f.sequence(:job_id) { |n| "job_id-#{n}" }
  f.attempt { 0 }
  f.handle { "" }
  f.html_url { "" }
  f.name { "" }
  f.needs { "[\"\"]" }
  f.owner_id { 0 }
  f.repo_id { 0 }
  f.run_id { 0 }
  f.runs_on { "[\"\"]" }
  f.status { "" }
  f.steps { "[{\"name\":\"\",\"number\":0,\"started\":\"2026-01-01T00:00:00Z\",\"status\":\"\",\"stopped\":\"2026-01-01T00:00:00Z\"}]" }
  f.task_id { 0 }
end
