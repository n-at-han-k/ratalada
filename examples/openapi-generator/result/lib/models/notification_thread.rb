# frozen_string_literal: true

# NotificationThread -- columns from models.json, over the table the migrations made.
module Models
  class NotificationThread < ROM::Relation[:sql]
    schema(:notification_thread, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :pinned, Types::Bool.optional
      attribute :repository, Types::Any, read: Parsed
      attribute :subject, Types::Any, read: Parsed
      attribute :unread, Types::Bool.optional
      attribute :updated_at, Types::String.optional
      attribute :url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
