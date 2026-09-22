/**
 * @prettier
 *
 * Replaces the syntax-highlighting plugin. That one registered swagger-ui's
 * own highlighter, wrapped it to fall back to a plain-text viewer, and
 * injected a theme registry read from `syntaxHighlight` config. None of it
 * survives: ReUI's CodeBlock brings its own themes through shiki.
 */
import { HighlightCode, SyntaxHighlighter } from "@/components/code-block"

const CodeBlockPlugin = () => ({
  components: {
    HighlightCode,
    SyntaxHighlighter,
  },
})

export default CodeBlockPlugin
