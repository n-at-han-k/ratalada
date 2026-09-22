#!/usr/bin/env python3
"""swagger-ui src/ -> frontend/, every import respelled as @/.

    python3 fork.py <a swagger-ui checkout> <frontend/>

HOW THE FORK WAS MADE, not how it is maintained: this DELETES the target and
writes it again, so running it on the tree as it stands discards everything
done to the fork since -- the tailwind conversion included. It is here so a
re-fork onto a newer upstream lands in the same shape, and so the layout in
FORK.md is a program rather than a description.

frontend/LICENSE, NOTICE, FORK.md, entrypoints/ and styles/application.css
are ours and are not written by this; restore them afterwards.
"""
import os, re, sys, shutil, posixpath, collections

SRC = sys.argv[1]            # .../swagger-ui
DST = sys.argv[2]            # .../template/frontend
CODE = (".js", ".jsx", ".ts", ".tsx")
KEEP_EXT = (".svg", ".scss", ".css", ".json", ".md")

def kebab(stem):
    s = re.sub(r"([a-z0-9])([A-Z])", r"\1-\2", stem)
    s = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1-\2", s)
    return s.lower()

def dest(p):
    """p is posix, relative to the swagger-ui checkout ('src/...')."""
    parts = p.split("/")
    assert parts[0] == "src", p
    rest = parts[1:]
    if rest == ["index.js"]:
        out = "lib/swagger/swagger-ui.js"
    elif rest[0] == "style":
        out = "styles/swagger/" + "/".join(rest[1:])
    elif rest[0] == "standalone":
        out = "lib/swagger/standalone/" + "/".join(rest[1:])
    elif rest[0] == "core" and rest[1] == "components":
        out = "components/swagger/" + "/".join(rest[2:])
    elif rest[0] == "core" and rest[1] == "containers":
        out = "components/swagger/containers/" + "/".join(rest[2:])
    elif rest[0] == "core" and rest[1] == "plugins" and len(rest) > 3 and rest[3] == "components":
        out = "components/swagger/%s/" % rest[2] + "/".join(rest[4:])
    elif rest[0] == "core":
        out = "lib/swagger/" + "/".join(rest[1:])
    else:
        raise SystemExit("unmapped: " + p)
    if out.startswith("components/swagger/"):           # shadcn spelling
        head, base = posixpath.split(out)
        stem, ext = posixpath.splitext(base)
        out = posixpath.join(head, kebab(stem) + ext)
    return out

# ── the map ────────────────────────────────────────────────────────────
files = []
for dp, _, fs in os.walk(posixpath.join(SRC, "src")):
    for f in fs:
        rel = posixpath.relpath(posixpath.join(dp, f), SRC)
        if posixpath.basename(rel).startswith("."):
            continue                     # .eslintrc and friends are upstream's, not ours
        files.append(rel)
files.sort()

MAP = {}
taken = collections.defaultdict(list)
for rel in files:
    d = dest(rel)
    MAP[rel] = d
    taken[d].append(rel)
clash = {d: v for d, v in taken.items() if len(v) > 1}
if clash:
    raise SystemExit("collision:\n" + "\n".join(f"{d} <- {v}" for d, v in clash.items()))

# ── import resolution ──────────────────────────────────────────────────
have = set(MAP)

def resolve(spec, frm):
    """spec as written in `frm` (a src-relative path) -> src-relative target, or None."""
    spec = spec.rstrip("/")             # `core/plugins/auth/` is a directory import
    if spec.startswith("."):
        base = posixpath.normpath(posixpath.join(posixpath.dirname(frm), spec))
    elif spec.startswith("core/") or spec.startswith("standalone/") or spec.startswith("style/"):
        base = "src/" + spec
    else:
        return None
    for cand in (base, *[base + e for e in CODE + KEEP_EXT],
                 *[base + "/index" + e for e in CODE]):
        if cand in have:
            return cand
    return None

def alias(target, spec):
    out = MAP[target]
    stem, ext = posixpath.splitext(out)
    return "@/" + (out if ext in KEEP_EXT else stem)

SPEC = re.compile(r'''((?:from|import|require)\s*\(?\s*)(["'])([^"']+)\2''')

# `@use "x"`, `@forward "x"`, `@include meta.load-css("x")`. Sass has no import
# alias, so these are respelled relative to frontend/, which vite.config.ts
# hands sass as a loadPath -- the `@/` of stylesheets.
SASS = re.compile(r'''((?:@use|@forward)\s+|load-css\(\s*)(["'])([^"']+)\2''')

def resolve_sass(spec, frm):
    """A sass partial: `../mixins` is `_mixins.scss` next door."""
    if spec.startswith("sass:"):
        return None
    base = posixpath.normpath(posixpath.join(posixpath.dirname(frm), spec)) \
        if spec.startswith(".") else "src/" + spec
    head, name = posixpath.split(base)
    for cand in (f"{head}/{name}.scss", f"{head}/_{name}.scss",
                 f"{base}/_index.scss", f"{base}/index.scss"):
        if cand in have:
            return cand
    return None

# ── write ──────────────────────────────────────────────────────────────
if os.path.isdir(DST):
    shutil.rmtree(DST)
rewritten = unresolved = 0
misses = collections.Counter()
for rel, out in MAP.items():
    target = posixpath.join(DST, out)
    os.makedirs(posixpath.dirname(target), exist_ok=True)
    if not rel.endswith(CODE + (".scss",)):
        shutil.copyfile(posixpath.join(SRC, rel), target)
        continue
    text = open(posixpath.join(SRC, rel), encoding="utf8").read()
    if rel.endswith(".scss"):
        def sass_sub(m):
            global rewritten, unresolved
            head, q, spec = m.groups()
            hit = resolve_sass(spec, rel)
            if hit:
                rewritten += 1
                # frontend-root-relative, with sass's own partial spelling
                # (`_x.scss` is used as `x`) put back.
                out = MAP[hit][:-len(".scss")]
                base, name = posixpath.split(out)
                return f"{head}{q}{posixpath.join(base, name.lstrip('_'))}{q}"
            if spec.startswith(".") or spec.split("/")[0] in ("core", "standalone", "style"):
                unresolved += 1
                misses[f"{rel}: {spec}"] += 1
            return m.group(0)
        open(target, "w", encoding="utf8").write(SASS.sub(sass_sub, text))
        continue
    def sub(m):
        global rewritten, unresolved
        head, q, spec = m.groups()
        hit = resolve(spec, rel)
        if hit:
            rewritten += 1
            return f"{head}{q}{alias(hit, spec)}{q}"
        if spec.startswith(".") or spec.split("/")[0] in ("core", "standalone", "style"):
            unresolved += 1
            misses[f"{rel}: {spec}"] += 1
        return m.group(0)
    open(target, "w", encoding="utf8").write(SPEC.sub(sub, text))

# Upstream runs every .js through babel, so some of them hold JSX. Vite reads
# JSX out of .jsx and .tsx only -- and since every import is an extensionless
# @/ alias, the rename costs nothing.
JSX = re.compile(r"<[A-Za-z][A-Za-z0-9.]*[\s/>]|</[A-Za-z]")
renamed = 0
for out in list(MAP.values()):
    target = posixpath.join(DST, out)
    if out.endswith(".js") and JSX.search(open(target, encoding="utf8").read()):
        os.rename(target, target[:-len(".js")] + ".jsx")
        renamed += 1

print(f"{len(MAP)} files, {rewritten} imports respelled, {unresolved} unresolved, {renamed} .js -> .jsx")
for k in list(misses)[:20]:
    print("  MISS", k)
