# frozen_string_literal: true

# What the <%= table(name) %> model maps to. Add methods here: a struct is data, and these
# are the only place behaviour over that data belongs.
module Entities
  class <%= constant(name) %> < ROM::Struct
  end
end
