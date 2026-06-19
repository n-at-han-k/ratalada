# frozen_string_literal: true

require "test_helper"

class RataladaTest < Minitest::Test
  def test_version
    refute_nil Ratalada::VERSION
  end
end
