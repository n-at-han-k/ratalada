import { PRODUCT, SPECS } from "./data"

export function ProductInfo() {
  return (
    <section
      id="details"
      aria-labelledby="details-heading"
      className="flex flex-col gap-6"
    >
      <header className="flex items-baseline gap-3">
        <h2
          id="details-heading"
          className="text-foreground text-lg leading-tight font-semibold tracking-tight md:text-xl"
        >
          Product Details
        </h2>
      </header>

      <div className="grid grid-cols-1 gap-8 lg:grid-cols-2 lg:gap-12">
        {/* About - editorial paragraph */}
        <div className="flex flex-col gap-3">
          <span className="text-muted-foreground text-xs font-medium tracking-[0.18em] uppercase">
            About
          </span>
          <p className="text-foreground text-base leading-relaxed text-pretty">
            {PRODUCT.description}
          </p>
        </div>

        {/* Specs - borderless key/value table */}
        <div className="flex flex-col gap-3">
          <span className="text-muted-foreground text-xs font-medium tracking-[0.18em] uppercase">
            Specs
          </span>
          <dl className="flex flex-col">
            {SPECS.map((row, index) => (
              <div
                key={row.label}
                className={
                  index === 0
                    ? "grid grid-cols-[7rem_minmax(0,1fr)] items-baseline gap-3 py-2.5"
                    : "border-border/60 grid grid-cols-[7rem_minmax(0,1fr)] items-baseline gap-3 border-t py-2.5"
                }
              >
                <dt className="text-muted-foreground text-xs">{row.label}</dt>
                <dd className="text-foreground text-sm leading-snug">
                  {row.value}
                </dd>
              </div>
            ))}
          </dl>
        </div>
      </div>
    </section>
  )
}