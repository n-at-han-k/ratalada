# frozen_string_literal: true

# A mail sink on ratalada. Requiring the adapter selects the backend that
# speaks SMTP (async-smtp, on protocol-smtp) and the frontend that turns this
# block into the app it calls — the same two seams ratalada/puma and
# ratalada/sinatra use, so `Server.run` here is ratalada's own, unchanged.
#
#   ruby server.rb
#   swaks --server 127.0.0.1:1025 --from me@example.test --to a@ratalada.local

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))

require "ratalada/smtp"
require "pathname"

MAILDROP = Pathname(ENV.fetch("MAILDROP", File.join(__dir__, "mail")))

def deliver(message)
  MAILDROP.mkpath
  MAILDROP.join("#{Time.now.strftime('%Y%m%d%H%M%S%6N')}.eml").then do |path|
    path.write(message.data)
    warn "smtp: #{message.from} -> #{message.to.join(', ')} " \
         "(#{message.bytesize} bytes) #{path}"
    "queued as #{path.basename}"
  end
end

Server.run do |message|
  case message
  in { from: /@blocked\.test\z/ }      then [550, "sender is unacceptable"]
  in { subject: /\Aping\z/i }          then "pong"
  in { to: [/@ratalada\.local\z/, *] } then ->(mail) { deliver(mail) }
  end
end
