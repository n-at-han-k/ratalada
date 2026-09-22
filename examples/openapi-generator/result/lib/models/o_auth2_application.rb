# frozen_string_literal: true

# OAuth2Application -- columns from models.json, over the table the migrations made.
module Models
  class OAuth2Application < ROM::Relation[:sql]
    schema(:o_auth2_application, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :client_id, Types::String.optional
      attribute :client_secret, Types::String.optional
      attribute :confidential_client, Types::Bool.optional
      attribute :created, Types::String.optional
      attribute :name, Types::String.optional
      attribute :redirect_uris, Types::Any, read: Parsed

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
