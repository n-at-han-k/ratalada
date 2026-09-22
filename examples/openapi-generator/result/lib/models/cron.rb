# frozen_string_literal: true

# Cron -- columns from models.json, over the table the migrations made.
module Models
  class Cron < ROM::Relation[:sql]
    schema(:cron, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :exec_times, Types::Integer.optional
      attribute :name, Types::String.optional
      attribute :next, Types::String.optional
      attribute :prev, Types::String.optional
      attribute :schedule, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
