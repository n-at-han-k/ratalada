# frozen_string_literal: true

# ActivityPub -- columns from models.json, over the table the migrations made.
module Models
  class ActivityPub < ROM::Relation[:sql]
    schema(:activity_pub, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :"repository-id", Types::String.optional
      attribute :"user-id", Types::String.optional
      attribute :"activity-id", Types::String.optional
      attribute :@context, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
