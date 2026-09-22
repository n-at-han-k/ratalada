# frozen_string_literal: true

require "rom-factory"

# Factories build through the relations, so they write what the columns
# hold and read back what the API answers.
unless defined?(Factory)
  Factory = ROM::Factory.configure do |config|
    config.rom = ROM_CONTAINER
  end
end

Dir[File.expand_path("factories/*.rb", __dir__)].sort.each { |file| require file }
