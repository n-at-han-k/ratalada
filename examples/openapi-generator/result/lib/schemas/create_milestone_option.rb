# frozen_string_literal: true

class Schemas::CreateMilestoneOption
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "CreateMilestoneOption options for creating a milestone",
    "type" => "object",
    "properties" => {
      "description" => {"type" => "string", "x-go-name" => "Description"},
      "due_on" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Deadline",
      },
      "state" => {
        "type" => "string",
        "enum" => ["open", "closed"],
        "x-go-name" => "State",
      },
      "title" => {"type" => "string", "x-go-name" => "Title"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
