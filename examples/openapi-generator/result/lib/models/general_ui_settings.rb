# frozen_string_literal: true

# GeneralUISettings -- columns from models.json, over the table the migrations made.
module Models
  class GeneralUISettings < ROM::Relation[:sql]
    schema(:general_ui_settings, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :allowed_reactions, Types::Any, read: Parsed
      attribute :custom_emojis, Types::Any, read: Parsed
      attribute :default_theme, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
