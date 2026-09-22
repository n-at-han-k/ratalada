# frozen_string_literal: true

# Branch -- columns from models.json, over the table the migrations made.
module Models
  class Branch < ROM::Relation[:sql]
    schema(:branch, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :branch, Types::String.optional
      attribute :commit, Types::Any, read: Parsed
      attribute :effective_branch_protection_name, Types::String.optional
      attribute :enable_status_check, Types::Bool.optional
      attribute :name, Types::String.optional
      attribute :protected, Types::Bool.optional
      attribute :required_approvals, Types::Integer.optional
      attribute :status_check_contexts, Types::Any, read: Parsed
      attribute :user_can_merge, Types::Bool.optional
      attribute :user_can_push, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
