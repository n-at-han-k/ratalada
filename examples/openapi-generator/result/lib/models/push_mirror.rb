# frozen_string_literal: true

# PushMirror -- columns from models.json, over the table the migrations made.
module Models
  class PushMirror < ROM::Relation[:sql]
    schema(:push_mirror, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :name, Types::String.optional
      attribute :branch_filter, Types::String.optional
      attribute :created, Types::String.optional
      attribute :interval, Types::String.optional
      attribute :last_error, Types::String.optional
      attribute :last_update, Types::String.optional
      attribute :public_key, Types::String.optional
      attribute :remote_address, Types::String.optional
      attribute :remote_name, Types::String.optional
      attribute :repo_name, Types::String.optional
      attribute :sync_on_commit, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
