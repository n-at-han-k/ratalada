# frozen_string_literal: true

# QuotaGroup -- generated from models.json.
Factory.define(:quota_group, relation: :quota_group) do |f|
  f.sequence(:quotagroup) { |n| "quotagroup-#{n}" }
  f.name { "" }
  f.rules { "[{\"limit\":0,\"name\":\"\",\"subjects\":[\"\"]}]" }
end
