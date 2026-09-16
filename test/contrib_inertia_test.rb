# frozen_string_literal: true

require "test_helper"
require "ratalada/contrib/inertia"

class ContribInertiaTest < Minitest::Test
  def test_registers_its_settings_with_defaults
    assert_equal "1", Ratalada.config.inertia_version
    assert_equal :layout, Ratalada.config.inertia_layout
    assert_equal false, Ratalada.config.inertia_encrypt_history
    assert_equal true, Ratalada.config.inertia_csrf_protection
    assert_equal [], Ratalada.config.inertia_share_blocks
  end

  def test_settings_are_configurable
    Ratalada.configure do |config|
      config.inertia_version = "abc123"
      config.inertia_encrypt_history = true
    end

    assert_equal "abc123", Ratalada.config.inertia_version
    assert_equal true, Ratalada.config.inertia_encrypt_history
  end

  def test_share_appends_blocks_to_the_config
    block = proc { { user: "nathan" } }
    Ratalada::Contrib::Inertia.share(&block)

    assert_equal [block], Ratalada.config.inertia_share_blocks
  end

  def test_share_requires_a_block
    assert_raises(ArgumentError) { Ratalada::Contrib::Inertia.share }
  end

  def test_share_props_is_an_alias_of_share
    block = proc { { user: "nathan" } }
    Ratalada::Contrib::Inertia.share_props(&block)

    assert_equal [block], Ratalada.config.inertia_share_blocks
  end

  def test_current_version_stringifies_the_setting
    assert_equal "1", Ratalada::Contrib::Inertia.current_version

    Ratalada.configure do |config|
      config.inertia_version = -> { 42 }
    end

    assert_equal "42", Ratalada::Contrib::Inertia.current_version
  end

  def test_middleware_defaults_its_version_to_the_config
    middleware = Ratalada::Contrib::Inertia::Middleware.new(->(_env) { [200, {}, []] })

    assert_equal "1", middleware.send(:current_version)

    Ratalada.configure do |config|
      config.inertia_version = "abc123"
    end

    assert_equal "abc123", middleware.send(:current_version)
  end
end
