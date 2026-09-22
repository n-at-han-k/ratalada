# frozen_string_literal: true

class Schemas::InternalTracker
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "InternalTracker represents settings for internal tracker",
    "type" => "object",
    "properties" => {
      "allow_only_contributors_to_track_time" => {
        "description" => "Let only contributors track time (Built-in issue tracker)",
        "type" => "boolean",
        "x-go-name" => "AllowOnlyContributorsToTrackTime",
      },
      "enable_issue_dependencies" => {
        "description" => "Enable dependencies for issues and pull requests (Built-in issue tracker)",
        "type" => "boolean",
        "x-go-name" => "EnableIssueDependencies",
      },
      "enable_time_tracker" => {
        "description" => "Enable time tracking (Built-in issue tracker)",
        "type" => "boolean",
        "x-go-name" => "EnableTimeTracker",
      },
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
