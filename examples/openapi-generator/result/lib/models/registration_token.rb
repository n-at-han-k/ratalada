# frozen_string_literal: true

# RegistrationToken -- columns from models.json, over the table the migrations made.
module Models
  class RegistrationToken < ROM::Relation[:sql]
    schema(:registration_token, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :token, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
