# frozen_string_literal: true

# Attachment -- columns from models.json, over the table the migrations made.
module Models
  class Attachment < ROM::Relation[:sql]
    schema(:attachment, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :attachment_id, Types::String.optional
      attribute :browser_download_url, Types::String.optional
      attribute :created_at, Types::String.optional
      attribute :download_count, Types::Integer.optional
      attribute :name, Types::String.optional
      attribute :size, Types::Integer.optional
      attribute :type, Types::String.optional
      attribute :uuid, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
