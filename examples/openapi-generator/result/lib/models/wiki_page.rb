# frozen_string_literal: true

# WikiPage -- columns from models.json, over the table the migrations made.
module Models
  class WikiPage < ROM::Relation[:sql]
    schema(:wiki_page, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :pageName, Types::String.optional
      attribute :commit_count, Types::Integer.optional
      attribute :content_base64, Types::String.optional
      attribute :footer, Types::String.optional
      attribute :html_url, Types::String.optional
      attribute :last_commit, Types::Any, read: Parsed
      attribute :sidebar, Types::String.optional
      attribute :sub_url, Types::String.optional
      attribute :title, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
