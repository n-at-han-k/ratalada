# frozen_string_literal: true

# TopicName -- columns from models.json, over the table the migrations made.
module Models
  class TopicName < ROM::Relation[:sql]
    schema(:topic_name, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :topics, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
