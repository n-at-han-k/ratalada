# frozen_string_literal: true

# RegisterRunnerResponse -- columns from models.json, over the table the migrations made.
module Models
  class RegisterRunnerResponse < ROM::Relation[:sql]
    schema(:register_runner_response, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :token, Types::String.optional
      attribute :uuid, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
