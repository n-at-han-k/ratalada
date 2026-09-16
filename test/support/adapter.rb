# frozen_string_literal: true

# Adapter specs have to require their adapter at file load — the group body
# names constants the require defines — but must not fail the suite when that
# adapter is not in the active bundle. `Adapter.load` at the top of the file
# records whether it came up; the `adapter:` metadata hook in spec_helper turns
# a miss into a skip.
module Adapter
  @available = {}

  class << self
    def load(path)
      @available[path] = try_require(path)
    end

    def available?(path) = @available.fetch(path, false)

    private

      # Requiring an adapter sets Ratalada.frontend as a side effect; put the
      # default router back so the rest of the suite (Server.run specs) keeps
      # building via Frontends::Routes.
      def try_require(path)
        require path
        Ratalada.frontend = Ratalada::Frontends::Routes
        true
      rescue LoadError
        false
      end
  end
end
