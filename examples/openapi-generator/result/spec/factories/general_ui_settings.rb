# frozen_string_literal: true

# GeneralUISettings -- generated from models.json.
Factory.define(:general_ui_setting, relation: :general_ui_settings) do |f|
  f.allowed_reactions { "[\"\"]" }
  f.custom_emojis { "[\"\"]" }
  f.default_theme { "" }
end
