# frozen_string_literal: true

# IssueTemplate -- columns from models.json, over the table the migrations made.
module Models
  class IssueTemplate < ROM::Relation[:sql]
    schema(:issue_template, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :about, Types::String.optional
      attribute :body, Types::Any, read: Parsed
      attribute :content, Types::String.optional
      attribute :file_name, Types::String.optional
      attribute :labels, Types::Any, read: Parsed
      attribute :name, Types::String.optional
      attribute :ref, Types::String.optional
      attribute :title, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
