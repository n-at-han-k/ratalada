// swagger-ui's dependency tree still expects a node runtime, and reads these
// as bare globals -- no import statement exists to alias, which is why
// upstream's webpack used ProvidePlugin for exactly this set.
//
// They are set at RUNTIME, not through vite's `define`: dev pre-bundles
// dependencies in a pass that never sees `define`, so a defined `Buffer` is
// present in our own source and absent in `deep-extend`, which is where it is
// actually read. Scanned for, not guessed: `Buffer` (deep-extend, js-yaml,
// lodash, randombytes), `process` (js-yaml, lodash, prop-types), `global`
// (immutable, dompurify, url-parse).
//
// `setImmediate` is deliberately NOT provided. react-dom feature-detects it
// and prefers it for scheduling when present; in a browser its MessageChannel
// path is the intended one.
//
// Our own code does not depend on any of this -- the sample encoders import
// Buffer explicitly (fn/encoders/*). This is for the packages we cannot edit.
import { Buffer } from "buffer"
import process from "process"

globalThis.global ??= globalThis
globalThis.Buffer ??= Buffer
globalThis.process ??= process
