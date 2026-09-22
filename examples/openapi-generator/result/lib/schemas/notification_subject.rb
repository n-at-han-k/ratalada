# frozen_string_literal: true

class Schemas::NotificationSubject
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "NotificationSubject contains the notification subject (Issue/Pull/Commit)",
    "type" => "object",
    "properties" => {
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "latest_comment_html_url" => {"type" => "string", "x-go-name" => "LatestCommentHTMLURL"},
      "latest_comment_url" => {"type" => "string", "x-go-name" => "LatestCommentURL"},
      "state" => {"$ref" => "#/components/schemas/StateType"},
      "title" => {"type" => "string", "x-go-name" => "Title"},
      "type" => {"$ref" => "#/components/schemas/NotifySubjectType"},
      "url" => {"type" => "string", "x-go-name" => "URL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
