# frozen_string_literal: true

require "spec_helper"

Dir[File.expand_path("../app/**/*.rb", __dir__)].sort.each do |page|
  lines = File.readlines(page)
  index = lines.index { |line| line.chomp == "__END__" }

  unless index.nil?
    eval(lines[(index + 1)..].join, TOPLEVEL_BINDING, page, index + 2) # rubocop:disable Security/Eval
  end
end
