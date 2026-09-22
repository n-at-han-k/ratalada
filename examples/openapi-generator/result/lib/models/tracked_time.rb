# frozen_string_literal: true

# TrackedTime -- columns from models.json, over the table the migrations made.
module Models
  class TrackedTime < ROM::Relation[:sql]
    schema(:tracked_time, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :created, Types::String.optional
      attribute :issue, Types::Any, read: Parsed
      attribute :issue_id, Types::Integer.optional
      attribute :time, Types::Integer.optional
      attribute :user_id, Types::Integer.optional
      attribute :user_name, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
