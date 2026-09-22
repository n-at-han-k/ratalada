# frozen_string_literal: true

# QuotaRuleInfo -- columns from models.json, over the table the migrations made.
module Models
  class QuotaRuleInfo < ROM::Relation[:sql]
    schema(:quota_rule_info, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :quotarule, Types::String.optional
      attribute :limit, Types::Integer.optional
      attribute :name, Types::String.optional
      attribute :subjects, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
