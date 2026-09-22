# frozen_string_literal: true

# QuotaGroup -- columns from models.json, over the table the migrations made.
module Models
  class QuotaGroup < ROM::Relation[:sql]
    schema(:quota_group, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :quotagroup, Types::String.optional
      attribute :name, Types::String.optional
      attribute :rules, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
