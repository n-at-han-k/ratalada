# frozen_string_literal: true

require "protocol/http"
require "protocol/url"

# Pattern matching for Protocol::HTTP::Request, so the router matches the
# request the server actually built instead of a wrapper standing in for it.
# `case request in ["GET", "/"]` needs #deconstruct and the class has none --
# unpatched, every pattern raises NoMatchingPatternError and every route 404s.
#
# Additions only: #path still returns the raw target ("/users/1?a=b"), which
# is what protocol-http1 writes and what anything else reading a request
# expects. The split path is what the patterns see, because a route is a path
# and "/hi" should match a request for "/hi?name=x".
module Protocol
  module HTTP
    class Request
      # The class overrides #method as a reader for the verb, so there is no
      # Object#method here to collide with -- and `in {verb:}` reads better
      # than `in {method:}` would.
      def verb = self.method

      def reference = @reference ||= ::Protocol::URL::Reference.parse(path)

      # "" rather than nil with no query string, so `in {query: ""}` means the
      # same here as on the rack router.
      def query = reference.query || ""

      def params
        if query.empty?
          @params ||= {}
        else
          @params ||= ::Protocol::URL::Encoding.decode(query)
        end
      end

      # Enables `in ["GET", "/"]`
      def deconstruct = [verb, reference.path.to_s]

      # Enables `in {verb: "GET", path: "/users"}`
      def deconstruct_keys(_keys) = { verb:, path: reference.path.to_s, query:, params:, headers:, body: }
    end
  end
end
