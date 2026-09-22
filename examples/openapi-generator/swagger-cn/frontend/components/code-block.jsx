/**
 * What the registry answers with for `HighlightCode` and `SyntaxHighlighter`.
 *
 * swagger-ui's own highlighting is gone -- react-syntax-highlighter, the
 * microlight styling, the theme config, the plugin that injected them. This
 * is ReUI's CodeBlock used the way it is meant to be: the block is the
 * chrome, `CodeBlockContent` is the surface, the copy button pins itself over
 * it, and the consumer owns the scrolling.
 *
 * Only the props swagger-ui passes are honoured, because those are the
 * contract the call sites already speak:
 *
 *   language      the syntax to highlight as
 *   children      the code, always a string
 *   canCopy       show the copy button
 *   downloadable  offer the body as a file
 *   fileName      what to call that file
 */
import React from "react"
import PropTypes from "prop-types"
import saveAs from "js-file-download"

import {
  CodeBlock,
  CodeBlockContent,
  CodeBlockCopyButton,
} from "@/components/reui/code-block/code-block"
import { ScrollArea, ScrollBar } from "@/components/ui/scroll-area"
import { Button } from "@/components/ui/button"

export const HighlightCode = ({
  fileName = "response.txt",
  className,
  downloadable = false,
  canCopy = false,
  language,
  children,
}) => (
  <CodeBlock code={String(children ?? "")} language={language} className={className}>
    {canCopy && (
      <CodeBlockCopyButton
        variant="outline"
        size="icon-sm"
        className="bg-card hover:bg-muted"
      />
    )}

    {/* The cap goes on the viewport, not the root: the viewport is height
        100% of the root, and a percentage against a max-height-only parent
        resolves to auto, so a root-level cap clips without ever scrolling. */}
    <ScrollArea className="rounded-[inherit] **:data-[slot=scroll-area-viewport]:max-h-96">
      <CodeBlockContent />
      <ScrollBar orientation="horizontal" />
    </ScrollArea>

    {downloadable && (
      <Button
        variant="outline"
        size="sm"
        className="m-2"
        onClick={() => saveAs(children, fileName)}
      >
        Download
      </Button>
    )}
  </CodeBlock>
)

HighlightCode.propTypes = {
  className: PropTypes.string,
  downloadable: PropTypes.bool,
  fileName: PropTypes.string,
  language: PropTypes.string,
  canCopy: PropTypes.bool,
  children: PropTypes.string,
}

// `curl.jsx` and the request-snippets panel ask for the bare highlighter
// rather than the whole block, and pass the code as children just the same.
export const SyntaxHighlighter = ({ language, className, children }) => (
  <HighlightCode language={language} className={className}>
    {children}
  </HighlightCode>
)

SyntaxHighlighter.propTypes = {
  language: PropTypes.string,
  className: PropTypes.string,
  children: PropTypes.node,
}
