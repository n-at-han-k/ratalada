/**
 * @prettier
 */
import React, { useMemo, useEffect, useCallback, useRef } from "react"
import PropTypes from "prop-types"
import ImPropTypes from "react-immutable-proptypes"
import cx from "classnames"
import randomBytes from "randombytes"
import { immutableToJS } from "@/lib/swagger/utils/index"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

const usePrevious = (value) => {
  const ref = useRef()
  useEffect(() => {
    ref.current = value
  })
  return ref.current
}

const useTabs = ({
  initialTab,
  isExecute,
  schema,
  example,
  specPath,
  layoutActions,
  layoutSelectors,
}) => {
  const tabs = useMemo(() => ({ example: "example", model: "model" }), [])
  const tabKey = useMemo(
    () => [...immutableToJS(specPath), "show-model-tab"],
    [specPath]
  )

  const showModelByDefault = !!(
    initialTab === tabs.model &&
    schema &&
    !isExecute
  )
  const showModel = layoutSelectors.isShown(tabKey, showModelByDefault)
  const activeTab = showModel ? tabs.model : tabs.example

  const prevIsExecute = usePrevious(isExecute)
  const isFirstRender = useRef(true)

  // ReUI's Tabs hand over the value; swagger read it off `data-name`.
  const handleTabChange = useCallback(
    (value) => {
      layoutActions.show(tabKey, value === tabs.model)
    },
    [layoutActions, tabKey, tabs.model]
  )

  useEffect(() => {
    if (isFirstRender.current) {
      isFirstRender.current = false
      return
    }

    const enteredExecute = !prevIsExecute && isExecute
    const leftExecuteWithExample = prevIsExecute && !isExecute && example

    if (enteredExecute || leftExecuteWithExample) {
      layoutActions.show(tabKey, false)
    }
  }, [prevIsExecute, isExecute, example, layoutActions, tabKey])

  return { activeTab, onTabChange: handleTabChange, tabs }
}

const ModelExample = ({
  schema,
  example,
  isExecute = false,
  specPath,
  includeWriteOnly = false,
  includeReadOnly = false,
  getComponent,
  getConfigs,
  specSelectors,
  layoutActions,
  layoutSelectors,
}) => {
  const { defaultModelRendering, defaultModelExpandDepth } = getConfigs()
  const ModelWrapper = getComponent("ModelWrapper")
  const HighlightCode = getComponent("HighlightCode", true)
  const exampleTabId = randomBytes(5).toString("base64")
  const examplePanelId = randomBytes(5).toString("base64")
  const modelTabId = randomBytes(5).toString("base64")
  const modelPanelId = randomBytes(5).toString("base64")
  const isOAS3 = specSelectors.isOAS3()
  const { activeTab, tabs, onTabChange } = useTabs({
    initialTab: defaultModelRendering,
    isExecute,
    schema,
    example,
    specPath,
    layoutActions,
    layoutSelectors,
  })

  return (
    <div className="model-example mt-[1em] [&_.model-container_.model-hint:not(.model-hint--embedded)]:top-[-1.15em]">
      <Tabs value={activeTab} onValueChange={onTabChange}>
        <TabsList>
          <TabsTrigger value={tabs.example} id={exampleTabId} aria-controls={examplePanelId}>
            {isExecute ? "Edit Value" : "Example Value"}
          </TabsTrigger>
          {schema && (
            <TabsTrigger value={tabs.model} id={modelTabId} aria-controls={modelPanelId}>
              {isOAS3 ? "Schema" : "Model"}
            </TabsTrigger>
          )}
        </TabsList>

        <TabsContent value={tabs.example} id={examplePanelId} aria-labelledby={exampleTabId}>
          {example ? example : <HighlightCode>(no example available)</HighlightCode>}
        </TabsContent>

        <TabsContent value={tabs.model} className="model-container" id={modelPanelId} aria-labelledby={modelTabId}>
          <ModelWrapper
            schema={schema}
            getComponent={getComponent}
            getConfigs={getConfigs}
            specSelectors={specSelectors}
            expandDepth={defaultModelExpandDepth}
            specPath={specPath}
            fullPath={immutableToJS(specPath)}
            layoutActions={layoutActions}
            layoutSelectors={layoutSelectors}
            includeReadOnly={includeReadOnly}
            includeWriteOnly={includeWriteOnly}
          />
        </TabsContent>
      </Tabs>
    </div>
  )
}

ModelExample.propTypes = {
  getComponent: PropTypes.func.isRequired,
  specSelectors: PropTypes.shape({ isOAS3: PropTypes.func.isRequired })
    .isRequired,
  layoutActions: PropTypes.object.isRequired,
  layoutSelectors: PropTypes.object.isRequired,
  schema: PropTypes.object.isRequired,
  example: PropTypes.any.isRequired,
  isExecute: PropTypes.bool,
  getConfigs: PropTypes.func.isRequired,
  specPath: ImPropTypes.list.isRequired,
  includeReadOnly: PropTypes.bool,
  includeWriteOnly: PropTypes.bool,
}

export default ModelExample
