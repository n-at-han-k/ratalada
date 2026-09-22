# frozen_string_literal: true

# PullReview -- columns from models.json, over the table the migrations made.
module Models
  class PullReview < ROM::Relation[:sql]
    schema(:pull_review, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :body, Types::String.optional
      attribute :comments_count, Types::Integer.optional
      attribute :commit_id, Types::String.optional
      attribute :dismissed, Types::Bool.optional
      attribute :html_url, Types::String.optional
      attribute :official, Types::Bool.optional
      attribute :pull_request_url, Types::String.optional
      attribute :stale, Types::Bool.optional
      attribute :state, Types::String.optional
      attribute :submitted_at, Types::String.optional
      attribute :team, Types::Any, read: Parsed
      attribute :updated_at, Types::String.optional
      attribute :user, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
