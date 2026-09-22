# frozen_string_literal: true

# PackageFile -- columns from models.json, over the table the migrations made.
module Models
  class PackageFile < ROM::Relation[:sql]
    schema(:package_file, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :Size, Types::Integer.optional
      attribute :md5, Types::String.optional
      attribute :name, Types::String.optional
      attribute :sha1, Types::String.optional
      attribute :sha256, Types::String.optional
      attribute :sha512, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
