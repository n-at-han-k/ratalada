# frozen_string_literal: true

# NotificationCount -- columns from models.json, over the table the migrations made.
module Models
  class NotificationCount < ROM::Relation[:sql]
    schema(:notification_count, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :new, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
