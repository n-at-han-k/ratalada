# frozen_string_literal: true

# LicenseTemplateInfo -- columns from models.json, over the table the migrations made.
module Models
  class LicenseTemplateInfo < ROM::Relation[:sql]
    schema(:license_template_info, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :body, Types::String.optional
      attribute :implementation, Types::String.optional
      attribute :key, Types::String.optional
      attribute :name, Types::String.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
