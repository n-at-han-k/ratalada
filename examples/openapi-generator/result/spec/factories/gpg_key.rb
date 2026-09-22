# frozen_string_literal: true

# GPGKey -- generated from models.json.
Factory.define(:gpg_key, relation: :gpg_key) do |f|
  f.sequence(:id) { |n| n }
  f.can_certify { false }
  f.can_encrypt_comms { false }
  f.can_encrypt_storage { false }
  f.can_sign { false }
  f.created_at { "2026-01-01T00:00:00Z" }
  f.emails { "[{\"email\":\"\",\"verified\":false}]" }
  f.expires_at { "2026-01-01T00:00:00Z" }
  f.key_id { "" }
  f.primary_key_id { "" }
  f.public_key { "" }
  f.subkeys { "[{}]" }
  f.verified { false }
end
