# frozen_string_literal: true

# NewIssuePinsAllowed -- generated from models.json.
Factory.define(:new_issue_pins_allowed, relation: :new_issue_pins_allowed) do |f|
  f.issues { false }
  f.pull_requests { false }
end
