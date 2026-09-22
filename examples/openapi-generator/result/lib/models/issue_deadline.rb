# frozen_string_literal: true

# IssueDeadline -- columns from models.json, over the table the migrations made.
module Models
  class IssueDeadline < ROM::Relation[:sql]
    schema(:issue_deadline, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :due_date, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
