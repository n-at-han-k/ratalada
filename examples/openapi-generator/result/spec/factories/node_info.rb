# frozen_string_literal: true

# NodeInfo -- generated from models.json.
Factory.define(:node_info, relation: :node_info) do |f|
  f.metadata { "{}" }
  f.openRegistrations { false }
  f.protocols { "[\"\"]" }
  f.services { "{\"inbound\":[\"\"],\"outbound\":[\"\"]}" }
  f.software { "{\"homepage\":\"\",\"name\":\"\",\"repository\":\"\",\"version\":\"\"}" }
  f.usage { "{\"localComments\":0,\"localPosts\":0,\"users\":{\"activeHalfyear\":0,\"activeMonth\":0,\"total\":0}}" }
  f.version { "" }
end
