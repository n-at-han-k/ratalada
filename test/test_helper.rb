# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ratalada"
require "dry/configurable/test_interface"
require "minitest/autorun"

# Global config is exercised by several tests; reset it to defaults after
# each so configured values never leak between them.
Ratalada.enable_test_interface

module RataladaConfigReset
  def after_teardown
    Ratalada.reset_config
    super
  end
end

Minitest::Test.include(RataladaConfigReset)
