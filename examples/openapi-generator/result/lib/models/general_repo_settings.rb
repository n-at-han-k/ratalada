# frozen_string_literal: true

# GeneralRepoSettings -- columns from models.json, over the table the migrations made.
module Models
  class GeneralRepoSettings < ROM::Relation[:sql]
    schema(:general_repo_settings, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :forks_disabled, Types::Bool.optional
      attribute :http_git_disabled, Types::Bool.optional
      attribute :lfs_disabled, Types::Bool.optional
      attribute :migrations_disabled, Types::Bool.optional
      attribute :mirrors_disabled, Types::Bool.optional
      attribute :stars_disabled, Types::Bool.optional
      attribute :time_tracking_disabled, Types::Bool.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
