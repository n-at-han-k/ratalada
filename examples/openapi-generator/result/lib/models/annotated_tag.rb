# frozen_string_literal: true

# AnnotatedTag -- columns from models.json, over the table the migrations made.
module Models
  class AnnotatedTag < ROM::Relation[:sql]
    schema(:annotated_tag, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :archive_download_count, Types::Any, read: Parsed
      attribute :message, Types::String.optional
      attribute :object, Types::Any, read: Parsed
      attribute :sha, Types::String.optional
      attribute :tag, Types::String.optional
      attribute :tagger, Types::Any, read: Parsed
      attribute :url, Types::String.optional
      attribute :verification, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
