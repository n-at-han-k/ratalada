# frozen_string_literal: true

# The check: spawn server.rb the way anyone else runs it, then talk SMTP to it
# with async-smtp's client, so every rung of the handler contract — a pair, a
# String, a callable, and no match at all — is exercised over a real socket.
#
#   ruby smoke.rb

require "async/smtp"
require "tmpdir"

PORT = 11_025
HOST = "127.0.0.1"

def assert(condition, message)
  case condition
  when true then warn "ok: #{message}"
  else raise "FAILED: #{message}"
  end
end

# The reply either way: a refusal arrives as an exception, and here it is the
# answer being checked rather than a problem.
def deliver(endpoint, from:, to:, subject: "Test")
  Async::SMTP::Client.open(endpoint) do |client|
    client.deliver(from: from, to: to, body: "Subject: #{subject}\r\n\r\nBody.\r\n")
  end
rescue Protocol::SMTP::ReplyError => error
  error.reply
end

# Give the spawned server five seconds to be listening, and say so plainly if
# it never is — every failure after this point would otherwise look like one.
def await(endpoint)
  listening = 100.times.find do
    begin
      endpoint.connect.close
      true
    rescue SystemCallError
      sleep 0.05
      false
    end
  end

  assert(!listening.nil?, "server.rb is listening on #{PORT}")
end

Dir.mktmpdir do |maildrop|
  pid = Process.spawn(
    { "MAILDROP" => maildrop, "PORT" => PORT.to_s },
    RbConfig.ruby,
    File.join(__dir__, "server.rb"),
  )

  begin
    Sync do
      endpoint = Async::SMTP::Endpoint.for(HOST, PORT)
      await(endpoint)

      blocked = deliver(endpoint, from: "spam@blocked.test", to: "a@ratalada.local")
      assert(blocked.code == 550, "a blocked sender is refused: #{blocked.inspect}")
      assert(blocked.text == "sender is unacceptable", "with the block's own text")

      ping = deliver(endpoint, from: "me@example.test", to: "a@ratalada.local", subject: "PING")
      assert(ping.code == 250 && ping.text == "pong", "a String is the text of a 250: #{ping.inspect}")

      queued = deliver(endpoint, from: "me@example.test", to: "a@ratalada.local")
      assert(queued.code == 250, "mail for the domain is queued: #{queued.inspect}")
      assert(Dir.children(maildrop).grep(/\.eml\z/).length == 1, "and the callable wrote it to the maildrop")

      elsewhere = deliver(endpoint, from: "me@example.test", to: "a@elsewhere.test")
      assert(elsewhere.code == 550, "an unmatched message is a 550: #{elsewhere.inspect}")
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

warn "smoke: all good"
