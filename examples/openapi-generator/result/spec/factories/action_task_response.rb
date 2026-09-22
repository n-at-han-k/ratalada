# frozen_string_literal: true

# ActionTaskResponse -- generated from models.json.
Factory.define(:action_task_response, relation: :action_task_response) do |f|
  f.total_count { 0 }
  f.workflow_runs { "[{\"created_at\":\"2026-01-01T00:00:00Z\",\"display_title\":\"\",\"event\":\"\",\"head_branch\":\"\",\"head_sha\":\"\",\"id\":0,\"name\":\"\",\"run_number\":0,\"run_started_at\":\"2026-01-01T00:00:00Z\",\"status\":\"\",\"updated_at\":\"2026-01-01T00:00:00Z\",\"url\":\"\",\"workflow_id\":\"\"}]" }
end
