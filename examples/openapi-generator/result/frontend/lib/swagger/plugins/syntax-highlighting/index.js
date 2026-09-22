/**
 * @prettier
 */
import afterLoad from "@/lib/swagger/plugins/syntax-highlighting/after-load"
import { styles, defaultStyle } from "@/lib/swagger/plugins/syntax-highlighting/root-injects"
import SyntaxHighlighter from "@/components/swagger/syntax-highlighting/syntax-highlighter"
import HighlightCode from "@/components/swagger/syntax-highlighting/highlight-code"
import PlainTextViewer from "@/components/swagger/syntax-highlighting/plain-text-viewer"
import SyntaxHighlighterWrapper from "@/lib/swagger/plugins/syntax-highlighting/wrap-components/SyntaxHighlighter"

const SyntaxHighlightingPlugin1 = () => ({
  afterLoad,
  rootInjects: {
    syntaxHighlighting: { styles, defaultStyle },
  },
  components: {
    SyntaxHighlighter,
    HighlightCode,
    PlainTextViewer,
  },
})

const SyntaxHighlightingPlugin2 = () => ({
  wrapComponents: {
    SyntaxHighlighter: SyntaxHighlighterWrapper,
  },
})

const SyntaxHighlightingPlugin = () => [
  SyntaxHighlightingPlugin1,
  SyntaxHighlightingPlugin2,
]

export default SyntaxHighlightingPlugin
