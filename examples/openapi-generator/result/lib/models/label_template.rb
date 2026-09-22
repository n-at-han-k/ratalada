# frozen_string_literal: true

# LabelTemplate -- columns from models.json, over the table the migrations made.
module Models
  class LabelTemplate < ROM::Relation[:sql]
    schema(:label_template, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :color, Types::String.optional
      attribute :description, Types::String.optional
      attribute :exclusive, Types::Bool.optional
      attribute :name, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
