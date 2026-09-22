# frozen_string_literal: true

# PackageFile -- generated from models.json.
Factory.define(:package_file, relation: :package_file) do |f|
  f.__send__(:Size) { 0 }
  f.md5 { "" }
  f.name { "" }
  f.sha1 { "" }
  f.sha256 { "" }
  f.sha512 { "" }
end
