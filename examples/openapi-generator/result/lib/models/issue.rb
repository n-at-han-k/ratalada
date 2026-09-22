# frozen_string_literal: true

# Issue -- columns from models.json, over the table the migrations made.
module Models
  class Issue < ROM::Relation[:sql]
    schema(:issue, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :index, Types::String.optional
      attribute :assets, Types::Any, read: Parsed
      attribute :assignee, Types::Any, read: Parsed
      attribute :assignees, Types::Any, read: Parsed
      attribute :body, Types::String.optional
      attribute :closed_at, Types::String.optional
      attribute :comments, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :due_date, Types::String.optional
      attribute :html_url, Types::String.optional
      attribute :is_locked, Types::Bool.optional
      attribute :labels, Types::Any, read: Parsed
      attribute :milestone, Types::Any, read: Parsed
      attribute :number, Types::Integer.optional
      attribute :original_author, Types::String.optional
      attribute :original_author_id, Types::Integer.optional
      attribute :pin_order, Types::Integer.optional
      attribute :pull_request, Types::Any, read: Parsed
      attribute :ref, Types::String.optional
      attribute :repository, Types::Any, read: Parsed
      attribute :state, Types::String.optional
      attribute :title, Types::String.optional
      attribute :updated_at, Types::String.optional
      attribute :url, Types::String.optional
      attribute :user, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
