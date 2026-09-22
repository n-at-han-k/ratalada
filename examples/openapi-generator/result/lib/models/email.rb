# frozen_string_literal: true

# Email -- columns from models.json, over the table the migrations made.
module Models
  class Email < ROM::Relation[:sql]
    schema(:email, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :email, Types::String.optional
      attribute :primary, Types::Bool.optional
      attribute :user_id, Types::Integer.optional
      attribute :username, Types::String.optional
      attribute :verified, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
