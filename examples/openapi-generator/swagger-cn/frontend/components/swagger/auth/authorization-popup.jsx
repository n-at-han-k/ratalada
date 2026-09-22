import React from "react"
import PropTypes from "prop-types"

import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { ScrollArea } from "@/components/ui/scroll-area"

/**
 * The authorizations modal.
 *
 * Was five nested divs -- dialog-ux, backdrop-ux, modal-ux, modal-dialog-ux,
 * modal-ux-inner -- plus a hand-rolled backdrop click, a close button with
 * its own icon, and a document-level Escape listener. Dialog does all four,
 * and adds the focus trap and `aria-modal` they never had.
 *
 * It renders open because swagger-ui only mounts it when there is something
 * to show; closing is telling swagger-ui that, not local state.
 */
export default class AuthorizationPopup extends React.Component {
  static propTypes = {
    fn: PropTypes.object.isRequired,
    getComponent: PropTypes.func.isRequired,
    authSelectors: PropTypes.object.isRequired,
    specSelectors: PropTypes.object.isRequired,
    errSelectors: PropTypes.object.isRequired,
    authActions: PropTypes.object.isRequired,
  }

  close = () => this.props.authActions.showDefinitions(false)

  render() {
    const {
      authSelectors,
      authActions,
      getComponent,
      errSelectors,
      specSelectors,
      fn: { AST = {} },
    } = this.props

    const definitions = authSelectors.shownDefinitions()
    const Auths = getComponent("auths")

    return (
      <Dialog open onOpenChange={(open) => !open && this.close()}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>Available authorizations</DialogTitle>
          </DialogHeader>

          <ScrollArea className="**:data-[slot=scroll-area-viewport]:max-h-[60vh]">
            <div className="space-y-6 pr-4">
              {definitions
                .valueSeq()
                .map((definition, key) => (
                  <Auths
                    key={key}
                    AST={AST}
                    definitions={definition}
                    getComponent={getComponent}
                    errSelectors={errSelectors}
                    authSelectors={authSelectors}
                    authActions={authActions}
                    specSelectors={specSelectors}
                  />
                ))}
            </div>
          </ScrollArea>
        </DialogContent>
      </Dialog>
    )
  }
}
