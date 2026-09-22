# frozen_string_literal: true

# UserSettings -- generated from models.json.
Factory.define(:user_setting, relation: :user_settings) do |f|
  f.description { "" }
  f.diff_view_style { "" }
  f.enable_repo_unit_hints { false }
  f.full_name { "" }
  f.hide_activity { false }
  f.hide_email { false }
  f.hide_pronouns { false }
  f.language { "" }
  f.location { "" }
  f.pronouns { "" }
  f.theme { "" }
  f.website { "" }
end
