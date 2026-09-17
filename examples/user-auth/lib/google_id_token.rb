# frozen_string_literal: true

require "jwt"
require "net/http"
require "json"
require "uri"

# Verification for the ID token Google One Tap hands the browser, consumed by
# the one-tap route in app/login.rb.
#
# The redirect flow needs nothing like this: omniauth-google-oauth2 gets the
# token over a back channel it opened itself and verifies it (`skip_jwt: false`
# in server.rb). One Tap is the opposite -- the token is minted in the browser
# and arrives as a form field, so at that point NOTHING has checked it. A
# merely decoded token is worth zero: anyone can mint one naming any email. The
# signature, issuer, audience and expiry are all checked here before
# app/login.rb is allowed to believe the address.
module GoogleIDToken
  CERTS   = "https://www.googleapis.com/oauth2/v3/certs"
  # Google stamps both spellings depending on the flow; both are legitimate.
  ISSUERS = ["accounts.google.com", "https://accounts.google.com"].freeze

  class << self
    # The verified claims, or nil for a token that fails any check -- callers
    # get no way to tell a forged token from an expired one apart, which is the
    # point.
    def claims(token, audience: ENV["GOOGLE_CLIENT_ID"])
      # No audience configured means nothing to check the token against, and
      # the only safe answer to that is no.
      if token.to_s.empty? || audience.to_s.empty?
        nil
      else
        verified(token, audience)
      end
    end

    private

      def verified(token, audience)
        payload, = JWT.decode(
          token,
          nil,
          true,
          algorithms:        ["RS256"],
          jwks:              ->(options) { jwks(refetch: options[:kid_not_found]) },
          # Without verify_aud a token minted for SOMEONE ELSE'S Google client
          # would sail through -- it is signed by Google and unexpired, and only
          # the audience says it was never meant for us.
          aud:               audience,
          verify_aud:        true,
          iss:               ISSUERS,
          verify_iss:        true,
          verify_expiration: true,
        )
        payload
      rescue JWT::DecodeError, JWT::JWKError
        nil
      end

      # Google rotates its signing keys, so a `kid` this process has never
      # seen is routine rather than an error: the decode above asks for one
      # refetch before giving up.
      #
      # ponytail: process-local, refetched only on a rotation miss. A shared
      # cache is worth it only if this fetch shows up in login latency.
      def jwks(refetch: false)
        if refetch || @jwks.nil?
          @jwks = JSON.parse(Net::HTTP.get(URI(CERTS)))
        end
        @jwks
      end
  end
end
