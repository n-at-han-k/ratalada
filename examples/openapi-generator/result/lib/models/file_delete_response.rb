# frozen_string_literal: true

# FileDeleteResponse -- columns from models.json, over the table the migrations made.
module Models
  class FileDeleteResponse < ROM::Relation[:sql]
    schema(:file_delete_response, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :filepath, Types::String.optional
      attribute :commit, Types::Any, read: Parsed
      attribute :content, Types::Any, read: Parsed
      attribute :verification, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
