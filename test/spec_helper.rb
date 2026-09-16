# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ratalada"
require "dry/configurable/test_interface"
require "stringio"

# Global config is exercised by several specs; reset it to defaults after each
# so configured values never leak between them.
Ratalada.enable_test_interface

Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |file| require file }

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |expectations| expectations.syntax = :expect }
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = ".rspec_status"
  config.order = :random
  Kernel.srand(config.seed)

  config.include RackEnv
  config.include BackendControl
  config.include_context "with a backend", :backend

  # `adapter: "ratalada/roda"` on a group skips it when that adapter is not in
  # the active bundle. Adapter.load at the top of the file did the requiring.
  config.before do |example|
    path = example.metadata[:adapter]

    unless path.nil? || Adapter.available?(path)
      skip "#{path} is not in the active bundle"
    end
  end

  # backend and frontend are settings too, and requiring ratalada/falcon or
  # ratalada/sinatra registers them once, at load — a plain reset would drop
  # what the requires set up and leave later examples with no backend.
  config.after do
    backend = Ratalada.config.backend
    frontend = Ratalada.config.frontend

    Ratalada.reset_config

    Ratalada.config.backend = backend
    Ratalada.config.frontend = frontend
  end
end
