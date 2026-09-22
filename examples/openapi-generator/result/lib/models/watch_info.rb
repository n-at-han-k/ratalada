# frozen_string_literal: true

# WatchInfo -- columns from models.json, over the table the migrations made.
module Models
  class WatchInfo < ROM::Relation[:sql]
    schema(:watch_info, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :created_at, Types::String.optional
      attribute :ignored, Types::Bool.optional
      attribute :reason, Types::Any, read: Parsed
      attribute :repository_url, Types::String.optional
      attribute :subscribed, Types::Bool.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
