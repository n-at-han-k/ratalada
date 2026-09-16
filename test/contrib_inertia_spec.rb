# frozen_string_literal: true

require "ratalada/contrib/inertia"

RSpec.describe Ratalada::Contrib::Inertia do
  it "registers its settings with defaults" do
    expect(Ratalada.config).to have_attributes(
      inertia_version:         "1",
      inertia_layout:          :layout,
      inertia_encrypt_history: false,
      inertia_csrf_protection: true,
      inertia_share_blocks:    [],
    )
  end

  it "makes its settings configurable" do
    Ratalada.configure do |config|
      config.inertia_version = "abc123"
      config.inertia_encrypt_history = true
    end

    expect(Ratalada.config.inertia_version).to eq("abc123")
    expect(Ratalada.config.inertia_encrypt_history).to be(true)
  end

  describe ".share" do
    it "appends blocks to the config" do
      block = proc { { user: "nathan" } }

      described_class.share(&block)

      expect(Ratalada.config.inertia_share_blocks).to eq([block])
    end

    it "requires a block" do
      expect { described_class.share }.to raise_error(ArgumentError)
    end
  end

  describe ".share_props" do
    it "is an alias of .share" do
      block = proc { { user: "nathan" } }

      described_class.share_props(&block)

      expect(Ratalada.config.inertia_share_blocks).to eq([block])
    end
  end

  describe ".current_version" do
    it "stringifies the setting" do
      expect(described_class.current_version).to eq("1")
    end

    it "stringifies a callable setting's result" do
      Ratalada.configure { |config| config.inertia_version = -> { 42 } }

      expect(described_class.current_version).to eq("42")
    end
  end

  describe Ratalada::Contrib::Inertia::Middleware do
    subject(:middleware) { described_class.new(->(_env) { [200, {}, []] }) }

    it "defaults its version to the config" do
      expect(middleware.send(:current_version)).to eq("1")

      Ratalada.configure { |config| config.inertia_version = "abc123" }

      expect(middleware.send(:current_version)).to eq("abc123")
    end
  end
end
