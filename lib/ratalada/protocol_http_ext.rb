# frozen_string_literal: true

require "protocol/http"
require "protocol/url"

# Pattern matching for Protocol::HTTP::Request.
module Protocol
  module HTTP
    class Request
      # Reads the verb; also gives `in {verb:}`.
      #
      # @returns [String] the request method.
      def verb = self.method

      def reference = @reference ||= ::Protocol::URL::Reference.parse(path)

      # The query string, "" when absent, as on the rack router.
      #
      # @returns [String] the query string.
      def query = reference.query || ""

      def params
        if query.empty?
          @params ||= {}
        else
          @params ||= ::Protocol::URL::Encoding.decode(query)
        end
      end

      # Enables `in ["GET", "/"]`.
      #
      # @returns [Array(String)] the verb and path.
      def deconstruct = [verb, reference.path.to_s]

      # Enables `in {verb: "GET", path: "/users"}`.
      #
      # @parameter _keys [Array(Symbol)] ignored.
      # @returns [Hash] the request's matchable fields.
      def deconstruct_keys(_keys) = { verb:, path: reference.path.to_s, query:, params:, headers:, body: }
    end
  end
end
