# frozen_string_literal: true

# FilesResponse -- columns from models.json, over the table the migrations made.
module Models
  class FilesResponse < ROM::Relation[:sql]
    schema(:files_response, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :commit, Types::Any, read: Parsed
      attribute :files, Types::Any, read: Parsed
      attribute :verification, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
