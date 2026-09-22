# frozen_string_literal: true

# QuotaRuleInfo -- generated from models.json.
Factory.define(:quota_rule_info, relation: :quota_rule_info) do |f|
  f.sequence(:quotarule) { |n| "quotarule-#{n}" }
  f.limit { 0 }
  f.name { "" }
  f.subjects { "[\"\"]" }
end
