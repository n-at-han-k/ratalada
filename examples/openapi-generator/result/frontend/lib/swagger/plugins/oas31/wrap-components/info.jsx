/**
 * @prettier
 */
import React from "react"

import { createOnlyOAS31ComponentWrapper } from "@/lib/swagger/plugins/oas31/fn"

const InfoWrapper = createOnlyOAS31ComponentWrapper(({ getSystem }) => {
  const system = getSystem()
  const OAS31Info = system.getComponent("OAS31Info", true)

  return <OAS31Info />
})

export default InfoWrapper
