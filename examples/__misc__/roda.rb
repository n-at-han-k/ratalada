# frozen_string_literal: true

# Run:  bundle exec ruby examples/roda.rb
# Try:  curl http://localhost:9292/
#       curl http://localhost:9292/up
#       curl http://localhost:9292/greet/world
#       curl http://localhost:9292/users/42
#       curl http://localhost:9292/users/42/posts

require "ratalada/falcon"
require "ratalada/roda"

Server.run do
  plugin :json

  route do |r|
    r.root do
      "hello from roda on falcon\n"
    end

    r.get "up" do
      "ok\n"
    end

    r.get "greet", String do |name|
      "hello #{name}\n"
    end

    # The routing tree: branch once, act on the way down, match the verb last.
    r.on "users", Integer do |id|
      user = { id: id }

      r.get "posts" do
        { user: user, posts: [] }
      end

      r.is do
        user
      end
    end
  end
end
