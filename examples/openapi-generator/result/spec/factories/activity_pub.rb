# frozen_string_literal: true

# ActivityPub -- generated from models.json.
Factory.define(:activity_pub, relation: :activity_pub) do |f|
  f.sequence(:"repository-id") { |n| "repository-id-#{n}" }
  f.__send__(:@context) { "" }
end
