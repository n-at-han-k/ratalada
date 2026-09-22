# frozen_string_literal: true

# Milestone -- columns from models.json, over the table the migrations made.
module Models
  class Milestone < ROM::Relation[:sql]
    schema(:milestone, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :closed_at, Types::String.optional
      attribute :closed_issues, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :description, Types::String.optional
      attribute :due_on, Types::String.optional
      attribute :open_issues, Types::Integer.optional
      attribute :state, Types::String.optional
      attribute :title, Types::String.optional
      attribute :updated_at, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
