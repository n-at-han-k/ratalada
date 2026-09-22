# frozen_string_literal: true

# Activity -- columns from models.json, over the table the migrations made.
module Models
  class Activity < ROM::Relation[:sql]
    schema(:activity, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :act_user, Types::Any, read: Parsed
      attribute :act_user_id, Types::Integer.optional
      attribute :comment, Types::Any, read: Parsed
      attribute :comment_id, Types::Integer.optional
      attribute :content, Types::String.optional
      attribute :created, Types::String.optional
      attribute :is_private, Types::Bool.optional
      attribute :op_type, Types::String.optional
      attribute :ref_name, Types::String.optional
      attribute :repo, Types::Any, read: Parsed
      attribute :repo_id, Types::Integer.optional
      attribute :user_id, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
