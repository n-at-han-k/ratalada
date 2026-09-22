# frozen_string_literal: true

# GeneralAPISettings -- generated from models.json.
Factory.define(:general_api_setting, relation: :general_api_settings) do |f|
  f.default_git_trees_per_page { 0 }
  f.default_max_blob_size { 0 }
  f.default_paging_num { 0 }
  f.max_response_items { 0 }
end
