import { useRef, useState, type KeyboardEvent } from "react"
import { cn } from "cn"

import { Item } from "@/components/ui/item"

import { GALLERY } from "./data"

export function ProductGallery() {
  const [activeIndex, setActiveIndex] = useState(0)
  const thumbRefs = useRef<Array<HTMLButtonElement | null>>([])
  const active = GALLERY[activeIndex] ?? GALLERY[0]

  function focusThumb(index: number) {
    const next = (index + GALLERY.length) % GALLERY.length
    setActiveIndex(next)
    thumbRefs.current[next]?.focus()
  }

  function onThumbKeyDown(
    event: KeyboardEvent<HTMLButtonElement>,
    index: number
  ) {
    if (event.key === "ArrowRight" || event.key === "ArrowDown") {
      event.preventDefault()
      focusThumb(index + 1)
    } else if (event.key === "ArrowLeft" || event.key === "ArrowUp") {
      event.preventDefault()
      focusThumb(index - 1)
    } else if (event.key === "Home") {
      event.preventDefault()
      focusThumb(0)
    } else if (event.key === "End") {
      event.preventDefault()
      focusThumb(GALLERY.length - 1)
    }
  }

  return (
    <div className="flex flex-col gap-3">
      {/* Featured image - short crossfade between selections */}
      <Item
        variant="muted"
        className="aspect-square w-full overflow-hidden p-0"
      >
        <img
          key={active.src}
          src={active.src}
          alt={active.alt}
          className="animate-in fade-in size-full object-cover duration-200 ease-out"
          loading="eager"
        />
      </Item>

      {/* Thumbnail strip - radiogroup with roving tabindex + arrow keys */}
      <div
        role="radiogroup"
        aria-label={`${GALLERY.length} product image thumbnails`}
        className="grid grid-cols-5 gap-2"
      >
        {GALLERY.map((shot, index) => {
          const isActive = index === activeIndex
          return (
            <Item
              key={shot.src}
              variant="muted"
              render={
                <button
                  type="button"
                  role="radio"
                  aria-checked={isActive}
                  aria-label={`Show image ${index + 1} of ${GALLERY.length}`}
                  tabIndex={isActive ? 0 : -1}
                  ref={(node) => {
                    thumbRefs.current[index] = node
                  }}
                  onClick={() => setActiveIndex(index)}
                  onKeyDown={(event) => onThumbKeyDown(event, index)}
                />
              }
              className={cn(
                "aspect-square w-full overflow-hidden p-0 transition",
                isActive
                  ? "ring-foreground ring-2"
                  : "focus-visible:ring-ring opacity-80 hover:opacity-100 focus-visible:ring-2"
              )}
            >
              <img
                src={shot.src}
                alt=""
                aria-hidden="true"
                className="size-full object-cover"
                loading="lazy"
              />
            </Item>
          )
        })}
      </div>
    </div>
  )
}