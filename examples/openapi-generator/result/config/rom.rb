# frozen_string_literal: true

require "fileutils"
require "json"
require "rom"
require "rom-sql"

require_relative "../lib/types"

# A file, not :memory:, so the data outlives the process that wrote it.
DB_PATH = File.expand_path("../db/api.sqlite", __dir__)

FileUtils.mkdir_p(File.dirname(DB_PATH))

DATABASE = ENV.fetch("DATABASE_URL") { "sqlite://#{DB_PATH}" }

ROM_CONFIG = ROM::Configuration.new(:sql, DATABASE)

# The tables the relations below are declared over. The migrator is
# idempotent: it applies what db/migrate holds and nothing it already has.
Sequel.extension(:migration)
Sequel::Migrator.run(ROM_CONFIG.gateways[:default].connection, File.expand_path("../db/migrate", __dir__))

# Entities first: a relation names the struct it maps to.
Dir[File.expand_path("../lib/entities/*.rb", __dir__)].sort.each { |file| require file }
Dir[File.expand_path("../lib/models/*.rb", __dir__)].sort.each { |file| require file }

ROM_CONFIG.register_relation(*Models.constants.map { |name| Models.const_get(name) })

ROM_CONTAINER = ROM.container(ROM_CONFIG)

# Last, after finalization has read every table's schema: a server that
# forks its workers would hand each of them the same sqlite handle, and
# the first to close it closes it for all of them. Sequel reconnects on
# demand, once per process.
ROM_CONFIG.gateways[:default].connection.disconnect
