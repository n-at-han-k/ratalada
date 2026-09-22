# frozen_string_literal: true

# WikiPageMetaData -- columns from models.json, over the table the migrations made.
module Models
  class WikiPageMetaData < ROM::Relation[:sql]
    schema(:wiki_page_meta_data, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :html_url, Types::String.optional
      attribute :last_commit, Types::Any, read: Parsed
      attribute :sub_url, Types::String.optional
      attribute :title, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
