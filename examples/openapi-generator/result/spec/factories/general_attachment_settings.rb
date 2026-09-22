# frozen_string_literal: true

# GeneralAttachmentSettings -- generated from models.json.
Factory.define(:general_attachment_setting, relation: :general_attachment_settings) do |f|
  f.allowed_types { "" }
  f.enabled { false }
  f.max_files { 0 }
  f.max_size { 0 }
end
