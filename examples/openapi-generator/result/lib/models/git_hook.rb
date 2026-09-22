# frozen_string_literal: true

# GitHook -- columns from models.json, over the table the migrations made.
module Models
  class GitHook < ROM::Relation[:sql]
    schema(:git_hook, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :content, Types::String.optional
      attribute :is_active, Types::Bool.optional
      attribute :name, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
