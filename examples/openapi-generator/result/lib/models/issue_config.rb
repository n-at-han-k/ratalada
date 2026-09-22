# frozen_string_literal: true

# IssueConfig -- columns from models.json, over the table the migrations made.
module Models
  class IssueConfig < ROM::Relation[:sql]
    schema(:issue_config, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :blank_issues_enabled, Types::Bool.optional
      attribute :contact_links, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
