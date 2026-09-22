/**
 * @prettier
 */

import { createOnlyOAS31SelectorWrapper } from "@/lib/swagger/plugins/oas31/fn"

export const isOAS3 =
  (oriSelector, system) =>
  (state, ...args) => {
    const isOAS31 = system.specSelectors.isOAS31()
    return isOAS31 || oriSelector(...args)
  }

export const selectLicenseUrl = createOnlyOAS31SelectorWrapper(
  () => (oriSelector, system) => {
    return system.oas31Selectors.selectLicenseUrl()
  }
)
