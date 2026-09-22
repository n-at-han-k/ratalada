# frozen_string_literal: true

# ── the ROM relations ─────────────────────────────────────────────────

def attribute_lines(name)
  columns(name).map do |var|
    if json_column?(var, name)
      # Text in the column, parsed on the way out: the response schema promised
      # an object, and an object is what comes out. Writes hand it the text
      # (see `accepted` in app/_layout.rb).
      #
      # `Any`, because the value the column holds and the value the API answers
      # with are different types, and the struct is built from the attribute's.
      "      attribute #{var["name"].to_sym.inspect}, Types::Any, read: Parsed"
    else
      "      attribute #{var["name"].to_sym.inspect}, #{rom_type(var)}.optional"
    end
  end
end

