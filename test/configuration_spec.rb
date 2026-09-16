# frozen_string_literal: true

RSpec.describe "Ratalada configuration" do
  describe "defaults" do
    it "comes from the constants" do
      expect(Ratalada.config.host).to eq(Ratalada::DEFAULT_HOST)
      expect(Ratalada.config.port).to eq(Ratalada::DEFAULT_PORT)
      expect(Ratalada.config.count).to eq(Ratalada::DEFAULT_COUNT)
    end
  end

  describe ".configure" do
    it "sets values" do
      Ratalada.configure do |config|
        config.host = "0.0.0.0"
        config.port = 3000
        config.count = 4
      end

      expect(Ratalada.config.host).to eq("0.0.0.0")
      expect(Ratalada.config.port).to eq(3000)
      expect(Ratalada.config.count).to eq(4)
    end

    it "coerces string port and count" do
      Ratalada.configure do |config|
        config.port = "3000"
        config.count = "2"
      end

      expect(Ratalada.config.port).to eq(3000)
      expect(Ratalada.config.count).to eq(2)
    end
  end

  describe "Server.run options", :backend do
    it "writes them through to the config" do
      Server.run(host: "example.test", port: 1234, count: 2) { |_request| "ok" }

      expect(backend).to have_attributes(host: "example.test", port: 1234, count: 2)
      expect(Ratalada.config).to have_attributes(host: "example.test", port: 1234, count: 2)
    end

    it "reads configured values when no options are given" do
      Ratalada.configure { |config| config.port = 4567 }

      Server.run { |_request| "ok" }

      expect(backend).to have_attributes(
        host:  Ratalada::DEFAULT_HOST,
        port:  4567,
        count: Ratalada::DEFAULT_COUNT,
      )
    end

    it "beats configured values" do
      Ratalada.configure { |config| config.port = 4567 }

      Server.run(port: 8901) { |_request| "ok" }

      expect(backend.port).to eq(8901)
    end

    it "rejects an unknown option as an unknown setting" do
      expect { Server.run(floogle: 1) { |_request| "ok" } }
        .to raise_error(ArgumentError, /floogle/)
    end

    [0, -1].each do |count|
      it "rejects a count of #{count}" do
        expect { Server.run(count: count) { |_request| "ok" } }.to raise_error(ArgumentError)
      end
    end

    # The constructor coerces before validation, so a numeric string is fine.
    it "accepts a numeric string count" do
      Server.run(count: "2") { |_request| "ok" }

      expect(backend.count).to eq(2)
    end
  end
end
