# frozen_string_literal: true

# ContentsResponse -- columns from models.json, over the table the migrations made.
module Models
  class ContentsResponse < ROM::Relation[:sql]
    schema(:contents_response, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :filepath, Types::String.optional
      attribute :_links, Types::Any, read: Parsed
      attribute :content, Types::String.optional
      attribute :download_url, Types::String.optional
      attribute :encoding, Types::String.optional
      attribute :git_url, Types::String.optional
      attribute :html_url, Types::String.optional
      attribute :last_commit_sha, Types::String.optional
      attribute :last_commit_when, Types::String.optional
      attribute :name, Types::String.optional
      attribute :path, Types::String.optional
      attribute :sha, Types::String.optional
      attribute :size, Types::Integer.optional
      attribute :submodule_git_url, Types::String.optional
      attribute :target, Types::String.optional
      attribute :type, Types::String.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
