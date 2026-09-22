# frozen_string_literal: true

# ── the patched generator ─────────────────────────────────────────────

GENERATOR = "openapi-generator-expo"

def pages(root)
  annotated = File.join(root, "tmp/annotated.json")
  out = File.join(root, "tmp/pages")

  write(annotated, JSON.generate(DOCUMENT))
  FileUtils.rm_rf(out)

  ok = system(
    GENERATOR,
    "generate",
    # models too: they are not written as files (the generator has no model
    # template) but `allModels` is only populated when they are generated, and
    # models.json is a supporting file built from it.
    "--global-property", "apis,models,supportingFiles",
    "-g", "ratalada-expo",
    "-i", annotated,
    "-t", File.join(TEMPLATE, "generators/expo/templates"),
    "-o", out,
    out: File::NULL,
  )

  unless ok
    abort("#{GENERATOR} failed")
  end

  File.join(out, "app")
end
