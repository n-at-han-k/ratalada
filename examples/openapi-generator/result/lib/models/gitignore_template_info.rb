# frozen_string_literal: true

# GitignoreTemplateInfo -- columns from models.json, over the table the migrations made.
module Models
  class GitignoreTemplateInfo < ROM::Relation[:sql]
    schema(:gitignore_template_info, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :name, Types::String.optional
      attribute :source, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
