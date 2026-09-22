# frozen_string_literal: true

# Tag -- columns from models.json, over the table the migrations made.
module Models
  class Tag < ROM::Relation[:sql]
    schema(:tag, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :tag, Types::String.optional
      attribute :archive_download_count, Types::Any, read: Parsed
      attribute :commit, Types::Any, read: Parsed
      attribute :message, Types::String.optional
      attribute :name, Types::String.optional
      attribute :tarball_url, Types::String.optional
      attribute :zipball_url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
