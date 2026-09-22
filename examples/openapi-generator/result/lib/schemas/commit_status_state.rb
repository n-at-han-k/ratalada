# frozen_string_literal: true

class Schemas::CommitStatusState
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CommitStatusState holds the state of a CommitStatus\nIt can be \"pending\", \"success\", \"error\", \"failure\", \"warning\", or \"skipped\"",
    "type" => "string",
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
