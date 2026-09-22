# frozen_string_literal: true

# StopWatch -- columns from models.json, over the table the migrations made.
module Models
  class StopWatch < ROM::Relation[:sql]
    schema(:stop_watch, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :created, Types::String.optional
      attribute :duration, Types::String.optional
      attribute :issue_index, Types::Integer.optional
      attribute :issue_title, Types::String.optional
      attribute :repo_name, Types::String.optional
      attribute :repo_owner_name, Types::String.optional
      attribute :seconds, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
