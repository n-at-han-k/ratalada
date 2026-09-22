# frozen_string_literal: true

# ── paths ──────────────────────────────────────────────────────────────

# `/orgs/{slug}` -> `["orgs", "[slug]"]`
#
# A segment can hold more than one parameter -- Forgejo's
# `/pulls/{index}.{diffType}` is `[index].[diffType]`, which Mustermann::Expo
# reads as capture, literal dot, capture -- so this substitutes each in place
# rather than matching the segment whole.
def segments(path)
  path.split(?/).reject(&:empty?).map do |segment|
    segment.gsub(/\{([^{}\/]+)\}/) { "[#{Regexp.last_match(1)}]" }
  end
end

# Swagger 2 keeps the shared prefix out of the paths; every route hangs off it,
# and it is what openapi_ruby is configured with as the server and the
# middleware's prefix.
def base = DOCUMENT.fetch("basePath", "").delete_suffix(?/)

def route(path) = segments(path).join(?/).then { |spelled| "/#{spelled}" }

# A path that is the prefix of another is a directory, and its own page is the
# `index.rb` inside it: `/orgs` and `/orgs/{slug}` cannot both be `orgs.rb`.
def file_for(path, paths)
  parts = segments(path)
  branch = paths.any? { |other| other.start_with?("#{path.delete_suffix(?/)}/") }

  if parts.empty?
    "index.rb"
  elsif branch
    File.join(*parts, "index.rb")
  else
    "#{File.join(*parts)}.rb"
  end
end

def check(relative, path)
  spelled = Mustermann::Expo.route(relative)

  unless spelled == route(path)
    abort("#{relative} spells #{spelled}, not #{route(path)} -- generator bug")
  end
end

def write(path, contents)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, contents)
end
