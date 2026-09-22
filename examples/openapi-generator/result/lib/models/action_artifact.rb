# frozen_string_literal: true

# ActionArtifact -- columns from models.json, over the table the migrations made.
module Models
  class ActionArtifact < ROM::Relation[:sql]
    schema(:action_artifact, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :artifact_id, Types::String.optional
      attribute :archive_download_url, Types::String.optional
      attribute :created_at, Types::String.optional
      attribute :expired, Types::Bool.optional
      attribute :expires_at, Types::String.optional
      attribute :name, Types::String.optional
      attribute :run_id, Types::Integer.optional
      attribute :size_in_bytes, Types::Integer.optional
      attribute :updated_at, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
