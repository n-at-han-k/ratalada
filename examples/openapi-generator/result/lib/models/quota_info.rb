# frozen_string_literal: true

# QuotaInfo -- columns from models.json, over the table the migrations made.
module Models
  class QuotaInfo < ROM::Relation[:sql]
    schema(:quota_info, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :groups, Types::Any, read: Parsed
      attribute :used, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
