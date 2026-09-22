# frozen_string_literal: true

# ChangedFile -- columns from models.json, over the table the migrations made.
module Models
  class ChangedFile < ROM::Relation[:sql]
    schema(:changed_file, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :additions, Types::Integer.optional
      attribute :changes, Types::Integer.optional
      attribute :contents_url, Types::String.optional
      attribute :deletions, Types::Integer.optional
      attribute :filename, Types::String.optional
      attribute :html_url, Types::String.optional
      attribute :previous_filename, Types::String.optional
      attribute :raw_url, Types::String.optional
      attribute :status, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
