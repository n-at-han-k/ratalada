# frozen_string_literal: true

# UserHeatmapData -- columns from models.json, over the table the migrations made.
module Models
  class UserHeatmapData < ROM::Relation[:sql]
    schema(:user_heatmap_data, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :contributions, Types::Integer.optional
      attribute :timestamp, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
