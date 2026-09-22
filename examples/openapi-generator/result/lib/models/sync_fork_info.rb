# frozen_string_literal: true

# SyncForkInfo -- columns from models.json, over the table the migrations made.
module Models
  class SyncForkInfo < ROM::Relation[:sql]
    schema(:sync_fork_info, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :branch, Types::String.optional
      attribute :allowed, Types::Bool.optional
      attribute :base_commit, Types::String.optional
      attribute :commits_behind, Types::Integer.optional
      attribute :fork_commit, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
