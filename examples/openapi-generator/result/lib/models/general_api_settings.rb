# frozen_string_literal: true

# GeneralAPISettings -- columns from models.json, over the table the migrations made.
module Models
  class GeneralAPISettings < ROM::Relation[:sql]
    schema(:general_api_settings, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :default_git_trees_per_page, Types::Integer.optional
      attribute :default_max_blob_size, Types::Integer.optional
      attribute :default_paging_num, Types::Integer.optional
      attribute :max_response_items, Types::Integer.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
