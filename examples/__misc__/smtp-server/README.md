# smtp-server

An SMTP server written the way ratalada writes HTTP ones: `Server.run` takes a
block, the block is called with each message and pattern matches on it, and
whatever it returns is the reply.

```ruby
Server.run do |message|
  case message
  in { from: /@blocked\.test\z/ }      then [550, "sender is unacceptable"]
  in { subject: /\Aping\z/i }          then "pong"
  in { to: [/@ratalada\.local\z/, *] } then ->(mail) { deliver(mail) }
  end
end
```

That is ratalada's own `Server.run`, unchanged. What `lib/ratalada/smtp.rb`
supplies is the pair of seams every ratalada adapter does — a backend that
runs the app ([async-smtp][async-smtp], on [protocol-smtp][protocol-smtp]) and
a frontend that turns the block into the app it calls — so the socket speaks
SMTP instead of HTTP and nothing else changes.

[async-smtp]: https://github.com/n-at-han-k/async-smtp
[protocol-smtp]: https://github.com/n-at-han-k/protocol-smtp

```sh
ruby server.rb        # listens on smtp://127.0.0.1:1025
ruby smoke.rb         # the check: spawns server.rb and delivers to it
bin/rubocop           # the style the repo's own cops ask for
```

Point a client at it:

```sh
swaks --server 127.0.0.1:1025 --from me@example.test --to a@ratalada.local
```

Accepted messages land in `./mail/*.eml`. `HOST`, `PORT`, `SMTP_DOMAIN` and
`MAILDROP` override the defaults; `port:` and `domain:` on `Server.run` take
precedence over the first two, and anything else it is given
(`maximum_message_size:`, `ssl_context:`) reaches protocol-smtp as it stands.

## The handler contract

The same one the HTTP router uses, with SMTP's codes:

- a `String` — the reply text, sent as `250`
- a callable — called with the message, its result handled the same way
- an `Integer` or `[code, text]` — used as given
- nothing (`nil`, or a fall-through `case ... in`) — a `550`, SMTP's `404`
- a `Protocol::SMTP::Reply` — sent as it stands

A raised exception is a `451` and a log entry, and the connection survives it:
async-smtp's doing, not this example's, on the grounds that a handler that
broke is the server's problem and the client may try again.

A message pattern matches as `[from, to]`, or by keys: `from`, `to`, `data`,
`helo`, `peer`, `headers`, `subject`, `body`. The envelope (`from`/`to`, what
the conversation said) and the headers (what the body claims) are both there
and neither is derived from the other — they disagree more often than people
expect.

## What it does not do

No AUTH, no relaying, no queue or retry — it is a sink that accepts mail and
hands it to your block, so it wants a trusted network. `count:` is ignored;
one reactor serves every connection. STARTTLS is there for the asking
(`Server.run(ssl_context:)`), and the transaction sequencing (RFC 5321 4.3.2),
dot stuffing, header unfolding and the size limit all live in protocol-smtp.

## Reference

`reference/` holds the upstream checkouts read while writing this, depended on
by neither this example nor the repo (it is untracked — clone it yourself):

```sh
git clone https://github.com/n-at-han-k/async-smtp.git reference/async-smtp
git clone https://github.com/n-at-han-k/protocol-smtp.git reference/protocol-smtp
git clone --depth 1 https://github.com/sj26/mailcatcher.git reference/mailcatcher
```

- `reference/protocol-smtp/lib/protocol/smtp/server.rb` — the state machine,
  and which code answers which out-of-sequence command
- `reference/async-smtp/lib/async/smtp/server.rb` — the loop this backend runs,
  and the reply it makes of what a handler returns
- `reference/mailcatcher/lib/mail_catcher/smtp.rb` — what a sink actually needs
  from it: re-issued `MAIL FROM`, the `SIZE=` suffix on the sender
