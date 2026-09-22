# frozen_string_literal: true

# PullReviewComment -- columns from models.json, over the table the migrations made.
module Models
  class PullReviewComment < ROM::Relation[:sql]
    schema(:pull_review_comment, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :comment, Types::String.optional
      attribute :body, Types::String.optional
      attribute :commit_id, Types::String.optional
      attribute :created_at, Types::String.optional
      attribute :diff_hunk, Types::String.optional
      attribute :extra_lines_count, Types::Integer.optional
      attribute :html_url, Types::String.optional
      attribute :original_commit_id, Types::String.optional
      attribute :original_position, Types::Integer.optional
      attribute :path, Types::String.optional
      attribute :position, Types::Integer.optional
      attribute :pull_request_review_id, Types::Integer.optional
      attribute :pull_request_url, Types::String.optional
      attribute :resolver, Types::Any, read: Parsed
      attribute :updated_at, Types::String.optional
      attribute :user, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
