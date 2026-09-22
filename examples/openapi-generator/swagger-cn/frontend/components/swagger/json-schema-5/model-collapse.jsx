import React, { Component } from "react"
import PropTypes from "prop-types"
import ImPropTypes from "react-immutable-proptypes"
import { List, is } from "immutable"
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion"

export default class ModelCollapse extends Component {
  static propTypes = {
    collapsedContent: PropTypes.any,
    expanded: PropTypes.bool,
    children: PropTypes.any,
    title: PropTypes.element,
    modelName: PropTypes.string,
    classes: PropTypes.string,
    onToggle: PropTypes.func,
    hideSelfOnExpand: PropTypes.bool,
    layoutActions: PropTypes.object,
    layoutSelectors: PropTypes.object.isRequired,
    specPath: ImPropTypes.list.isRequired,
  }

  static defaultProps = {
    collapsedContent: "{...}",
    expanded: false,
    title: null,
    onToggle: () => {},
    hideSelfOnExpand: false,
    specPath: List([]),
  }

  constructor(props, context) {
    super(props, context)

    let { expanded, collapsedContent } = this.props

    this.state = {
      expanded : expanded,
      collapsedContent: collapsedContent || ModelCollapse.defaultProps.collapsedContent
    }
  }

  componentDidMount() {
    const { hideSelfOnExpand, expanded, modelName } = this.props
    if(hideSelfOnExpand && expanded) {
      // We just mounted pre-expanded, and we won't be going back..
      // So let's give our parent an `onToggle` call..
      // Since otherwise it will never be called.
      this.props.onToggle(modelName, expanded)
    }
  }

  UNSAFE_componentWillReceiveProps(nextProps){
    if(this.props.expanded !== nextProps.expanded){
        this.setState({expanded: nextProps.expanded})
    }
  }

  toggleCollapsed=()=>{
    if(this.props.onToggle){
      this.props.onToggle(this.props.modelName,!this.state.expanded)
    }

    this.setState({
      expanded: !this.state.expanded
    })
  }

  onLoad = (ref) => {
    if (ref && this.props.layoutSelectors) {
      const scrollToKey = this.props.layoutSelectors.getScrollToKey()

      if( is(scrollToKey, this.props.specPath) ) this.toggleCollapsed()
      this.props.layoutActions.readyToScroll(this.props.specPath, ref.parentElement)
    }
  }

  render () {
    const { title, classes } = this.props

    if(this.state.expanded ) {
      if(this.props.hideSelfOnExpand) {
        return <div className={`${classes || ""} block w-full`}>
          {this.props.children}
        </div>
      }
    }

    // Each model row is its own accordion. `model-toggle` was an empty span
    // that CSS drew a chevron on; the trigger brings its own, so it is gone.
    const value = this.props.modelName || "model"

    return (
      <Accordion
        multiple
        value={this.state.expanded ? [value] : []}
        onValueChange={() => this.toggleCollapsed()}
        className="border-0"
      >
        <AccordionItem
          value={value}
          className={`${classes || ""} border-0`}
          ref={this.onLoad}
        >
          <AccordionTrigger
            render={<span />}
            nativeButton={false}
            className="model-box-control w-full cursor-pointer items-center py-1 hover:no-underline [&>*:first-child]:flex-1 [&>*:first-child]:w-full"
          >
            {title && <span className="pointer">{title}</span>}
            {!this.state.expanded && <span>{this.state.collapsedContent}</span>}
          </AccordionTrigger>
          <AccordionContent className="px-0 pt-0 pb-0">
            {this.props.children}
          </AccordionContent>
        </AccordionItem>
      </Accordion>
    )
  }
}
