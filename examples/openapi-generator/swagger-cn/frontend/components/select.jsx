/**
 * What the registry answers with for `Select`.
 *
 * swagger-ui's own was a controlled native <select>; ReUI's is Base UI's,
 * which is composed rather than a single element. The call sites are not
 * changing, so the props they already pass are the contract:
 *
 *   allowedValues    the options. Either plain values, or {value, label}
 *                    objects where the two differ -- the examples picker
 *                    shows a summary but selects by example name
 *   value            the current one; may arrive as an Immutable list
 *   multiple         several at once
 *   allowEmptyValue  offer a "--" option that clears the choice
 *   onChange(value)  called with the VALUE, not an event -- swagger-ui
 *                    unwrapped the event itself, so this keeps doing it
 */
import React from "react"
import PropTypes from "prop-types"

import {
  Select as SelectRoot,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"

const EMPTY = "\u0000empty"

export const Select = ({
  allowedValues = [],
  value,
  onChange,
  multiple = false,
  allowEmptyValue = true,
  className,
  disabled,
  title,
  ...rest
}) => {
  const current = value?.toJS?.() ?? value
  const selected = multiple
    ? (Array.isArray(current) ? current : [current]).filter((v) => v != null && v !== "")
    : current == null || current === ""
      ? EMPTY
      : String(current)

  const handle = (next) => {
    if (!onChange) return
    if (multiple) return onChange((next ?? []).map(String))
    onChange(next === EMPTY ? "" : next)
  }

  return (
    <SelectRoot value={selected} onValueChange={handle} multiple={multiple} disabled={disabled}>
      <SelectTrigger className={className} title={title} {...rest}>
        <SelectValue />
      </SelectTrigger>
      <SelectContent alignItemWithTrigger={false}>
        <SelectGroup>
          {allowEmptyValue && !multiple && <SelectItem value={EMPTY}>--</SelectItem>}
          {allowedValues.map((item, key) => {
            const value = item?.value ?? item
            const label = item?.label ?? item
            return (
              <SelectItem key={key} value={String(value)}>
                {String(label)}
              </SelectItem>
            )
          })}
        </SelectGroup>
      </SelectContent>
    </SelectRoot>
  )
}

Select.propTypes = {
  allowedValues: PropTypes.array,
  value: PropTypes.any,
  onChange: PropTypes.func,
  multiple: PropTypes.bool,
  allowEmptyValue: PropTypes.bool,
  className: PropTypes.string,
  disabled: PropTypes.bool,
  title: PropTypes.any,
}

export default Select
