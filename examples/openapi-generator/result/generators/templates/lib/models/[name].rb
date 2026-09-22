# frozen_string_literal: true

# <%= name %> -- columns from models.json, over the table the migrations made.
module Models
  class <%= constant(name) %> < ROM::Relation[:sql]
    schema(<%= table(name).to_sym.inspect %>, infer: false) do
<%= attribute_lines(name).join("\n") %>

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
