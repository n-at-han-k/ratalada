# frozen_string_literal: true

# IssueConfigValidation -- columns from models.json, over the table the migrations made.
module Models
  class IssueConfigValidation < ROM::Relation[:sql]
    schema(:issue_config_validation, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :message, Types::String.optional
      attribute :valid, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
