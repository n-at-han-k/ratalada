# frozen_string_literal: true

# GeneralAttachmentSettings -- columns from models.json, over the table the migrations made.
module Models
  class GeneralAttachmentSettings < ROM::Relation[:sql]
    schema(:general_attachment_settings, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :allowed_types, Types::String.optional
      attribute :enabled, Types::Bool.optional
      attribute :max_files, Types::Integer.optional
      attribute :max_size, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
