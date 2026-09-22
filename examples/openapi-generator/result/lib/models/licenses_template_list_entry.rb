# frozen_string_literal: true

# LicensesTemplateListEntry -- columns from models.json, over the table the migrations made.
module Models
  class LicensesTemplateListEntry < ROM::Relation[:sql]
    schema(:licenses_template_list_entry, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :key, Types::String.optional
      attribute :name, Types::String.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
