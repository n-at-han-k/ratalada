# frozen_string_literal: true

# Loads adapter specs only when the gem is bundled.
module Adapter
  @available = {}

  class << self
    def load(path)
      @available[path] = try_require(path)
    end

    def available?(path) = @available.fetch(path, false)

    private

      # Requiring an adapter sets Ratalada.frontend as a side effect; put the default router back so the rest of the suite (Server.run specs) keeps building via Frontends::Routes.
      def try_require(path)
        require path
        Ratalada.config.frontend = Ratalada::Frontends::Routes
        true
      rescue LoadError
        false
      end
  end
end
