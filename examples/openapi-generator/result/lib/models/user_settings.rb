# frozen_string_literal: true

# UserSettings -- columns from models.json, over the table the migrations made.
module Models
  class UserSettings < ROM::Relation[:sql]
    schema(:user_settings, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :description, Types::String.optional
      attribute :diff_view_style, Types::String.optional
      attribute :enable_repo_unit_hints, Types::Bool.optional
      attribute :full_name, Types::String.optional
      attribute :hide_activity, Types::Bool.optional
      attribute :hide_email, Types::Bool.optional
      attribute :hide_pronouns, Types::Bool.optional
      attribute :language, Types::String.optional
      attribute :location, Types::String.optional
      attribute :pronouns, Types::String.optional
      attribute :theme, Types::String.optional
      attribute :website, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
