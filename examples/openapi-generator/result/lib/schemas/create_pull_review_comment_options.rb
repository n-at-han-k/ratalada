# frozen_string_literal: true

class Schemas::CreatePullReviewCommentOptions
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({"$ref" => "#/components/schemas/CreatePullReviewComment"})
end
