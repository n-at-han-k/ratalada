# frozen_string_literal: true

# IssueConfig -- generated from models.json.
Factory.define(:issue_config, relation: :issue_config) do |f|
  f.blank_issues_enabled { false }
  f.contact_links { "[{\"about\":\"\",\"name\":\"\",\"url\":\"\"}]" }
end
