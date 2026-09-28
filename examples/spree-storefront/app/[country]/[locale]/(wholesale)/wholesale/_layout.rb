# frozen_string_literal: true

# reui: none
#
# <div>
#   {children}                                # 404s when the wholesale addon is off

# Wholesale is an opt-in addon: when it's off, every route under this group
# 404s here in one place, rather than each of the seven pages checking on its
# own.
before do
  next unless ENV["WHOLESALE_ADDON_DISABLED"] == "true"

  status(404)
  halt(inertia("+not-found"))
end

helpers do
  # ponytail: fixture props, swap for the Spree Store API (wholesale price
  # list + variant catalog) call when it is wired.
  def wholesale_products
    [
      {slug: "case-of-mugs", name: "Stoneware Mug, 12oz", sku: "MUG-STN-12OZ",
       category: "Drinkware", case_pack: 24, trade_price: 4.25, retail_price: 8.50,
       image: "https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=800&q=80"},
      {slug: "linen-tea-towel-case", name: "Linen Tea Towel, set of 3", sku: "TWL-LIN-20X28",
       category: "Kitchen Textiles", case_pack: 48, trade_price: 3.10, retail_price: 6.00,
       image: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80"},
      {slug: "olive-wood-board-case", name: "Olive Wood Serving Board", sku: "BRD-OLV-14IN",
       category: "Serveware", case_pack: 12, trade_price: 11.75, retail_price: 24.00,
       image: "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=800&q=80"},
      {slug: "cast-iron-trivet-case", name: "Cast Iron Trivet", sku: "TRV-CST-6IN",
       category: "Kitchen Textiles", case_pack: 36, trade_price: 2.60, retail_price: 5.50,
       image: "https://images.unsplash.com/photo-1611175694989-4870fabe75dd?w=800&q=80"},
      {slug: "handblown-tumbler-case", name: "Handblown Tumbler, 10oz", sku: "TUM-HBL-10OZ",
       category: "Drinkware", case_pack: 24, trade_price: 5.90, retail_price: 12.00,
       image: "https://images.unsplash.com/photo-1541599468348-e96984315921?w=800&q=80"},
    ]
  end

  def wholesale_product(slug) = wholesale_products.find { |p| p[:slug] == slug }

  def wholesale_customer
    {name: "Jordan Vance", email: "jordan@northstartrading.com", company: "Northstar Trading Co."}
  end

  # guest | pending | approved. Stands in for "no session", "signed in but not
  # in the Wholesale group yet" and "signed in and approved" -- there is no
  # Spree session or customer group behind it.
  def wholesale_status
    session[:wholesale_status] || "guest"
  end
end

__END__

import type { PropsWithChildren } from "react"

export default function WholesaleLayout({ children }: PropsWithChildren) {
  return <>{children}</>
}
