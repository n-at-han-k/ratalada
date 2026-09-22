# frozen_string_literal: true

# NewIssuePinsAllowed -- columns from models.json, over the table the migrations made.
module Models
  class NewIssuePinsAllowed < ROM::Relation[:sql]
    schema(:new_issue_pins_allowed, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :issues, Types::Bool.optional
      attribute :pull_requests, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
