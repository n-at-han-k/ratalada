# frozen_string_literal: true

# QuotaInfo -- generated from models.json.
Factory.define(:quota_info, relation: :quota_info) do |f|
  f.groups { "[{\"name\":\"\",\"rules\":[{\"limit\":0,\"name\":\"\",\"subjects\":[\"\"]}]}]" }
  f.used { "{\"size\":{\"assets\":{\"artifacts\":0,\"attachments\":{\"issues\":0,\"releases\":0},\"packages\":{\"all\":0}},\"git\":{\"LFS\":0},\"repos\":{\"private\":0,\"public\":0}}}" }
end
