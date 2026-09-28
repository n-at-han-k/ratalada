# frozen_string_literal: true

# reui: navbar-12, autocomplete  (footer: no reui block, hand-roll from ui primitives)
#
# <Header>                                    # blocks/navbar-12/navbar
#   <NavigationMenu>                          # category mega-menu, from the block
#   <Link>                                    # logo
#     <Image>
#   <NavbarActions>                           # blocks/navbar-12/navbar-actions
#     <Link>                                  # wholesale
#     <RegionPreferences>                     # ui/dropdown-menu
#     <Button>                                # account
#       <User>
#     <CartButton>
#       <ShoppingBag>
#       <Badge>                               # reui/badge — item count
#     <Button>                                # search toggle
#   <SearchBar>                               # reui/autocomplete
#     <AutocompleteInput>
#     <AutocompleteList>
#       <AutocompleteItem>                    # suggestion + thumbnail
# <main>
#   {children}
# <Footer>                                    # hand-roll: ui/separator + link columns
#   <ul>
#     <li>
#       <Link>                                # shop / categories
#   <ul>
#     <li>
#       <Link>                                # account / orders / cart / wholesale
#   <ul>
#     <li>
#       <Link>                                # policies

__END__

import type { PropsWithChildren } from "react"
import { useEffect, useState } from "react"
import { Link } from "@inertiajs/react"
import { Autocomplete } from "@base-ui/react/autocomplete"
import { SearchIcon, ShoppingBagIcon, UserIcon, ChevronDownIcon } from "lucide-react"

import { Badge } from "@/components/reui/badge"
import {
  AutocompleteInput,
  AutocompletePortal,
  AutocompletePositioner,
  AutocompleteContent,
  AutocompleteList,
  AutocompleteItem,
  AutocompleteEmpty,
} from "@/components/reui/autocomplete"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList,
  NavigationMenuTrigger,
} from "@/components/ui/navigation-menu"
import { Separator } from "@/components/ui/separator"
import { useCart } from "@/contexts/cart"

// ponytail: fixture categories/markets/products, swap for the Store API when it is wired
const CATEGORIES = [
  { name: "Bags", permalink: "bags" },
  { name: "Outerwear", permalink: "outerwear" },
  { name: "Footwear", permalink: "footwear" },
  { name: "Accessories", permalink: "accessories" },
]

const MARKETS = [
  { label: "United States (USD)", country: "us" },
  { label: "Canada (CAD)", country: "ca" },
  { label: "United Kingdom (GBP)", country: "gb" },
]

const SEARCH_SUGGESTIONS = [
  { slug: "canvas-weekender", name: "Canvas Weekender", image: "https://picsum.photos/seed/weekender/80/80" },
  { slug: "leather-tote", name: "Leather Tote", image: "https://picsum.photos/seed/tote/80/80" },
  { slug: "suede-boots", name: "Suede Boots", image: "https://picsum.photos/seed/boots/80/80" },
]

function CategoryMenu() {
  return (
    <NavigationMenu className="hidden lg:flex">
      <NavigationMenuList>
        {CATEGORIES.map((category) => (
          <NavigationMenuItem key={category.permalink}>
            <NavigationMenuTrigger>{category.name}</NavigationMenuTrigger>
            <NavigationMenuContent>
              <NavigationMenuLink render={<Link href={`/c/${category.permalink}`} />} className="w-48">
                Shop all {category.name}
              </NavigationMenuLink>
            </NavigationMenuContent>
          </NavigationMenuItem>
        ))}
      </NavigationMenuList>
    </NavigationMenu>
  )
}

function RegionPreferences() {
  return (
    <DropdownMenu>
      <DropdownMenuTrigger
        render={
          <Button variant="ghost" size="sm" className="hidden md:inline-flex">
            United States <ChevronDownIcon className="size-3.5" aria-hidden="true" />
          </Button>
        }
      />
      <DropdownMenuContent align="end">
        {MARKETS.map((market) => (
          <DropdownMenuItem key={market.country} render={<Link href={`/${market.country}/en`} />}>
            {market.label}
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  )
}

function CartButton() {
  const { count, open } = useCart()
  return (
    <Button variant="ghost" size="icon-lg" aria-label={`Cart, ${count} items`} onClick={open} className="relative">
      <ShoppingBagIcon aria-hidden="true" />
      {count > 0 && (
        <Badge size="xs" className="absolute -top-0.5 -right-0.5 rounded-full!">
          {count}
        </Badge>
      )}
    </Button>
  )
}

function SearchBar() {
  return (
    <Autocomplete.Root items={SEARCH_SUGGESTIONS} itemToStringLabel={(item) => item.name}>
      <div className="mx-auto hidden w-full max-w-sm md:block">
        <AutocompleteInput placeholder="Search products…" aria-label="Search products" />
        <AutocompletePortal>
          <AutocompletePositioner>
            <AutocompleteContent>
              <AutocompleteEmpty>No products found.</AutocompleteEmpty>
              <AutocompleteList>
                {(item: (typeof SEARCH_SUGGESTIONS)[number]) => (
                  <AutocompleteItem key={item.slug} value={item} render={<Link href={`/products/${item.slug}`} />}>
                    <img src={item.image} alt="" className="size-8 shrink-0 rounded object-cover" />
                    {item.name}
                  </AutocompleteItem>
                )}
              </AutocompleteList>
            </AutocompleteContent>
          </AutocompletePositioner>
        </AutocompletePortal>
      </div>
    </Autocomplete.Root>
  )
}

function Header() {
  return (
    <header className="border-border bg-background sticky top-0 z-20 border-b">
      <div className="mx-auto flex h-16 w-full max-w-6xl items-center gap-4 px-4">
        <Link href="/" className="shrink-0 text-lg font-semibold tracking-tight">
          Spree
        </Link>

        <CategoryMenu />

        <SearchBar />

        <div className="ml-auto flex items-center gap-1">
          <Link href="/wholesale" className="hover:text-foreground text-muted-foreground hidden px-2 text-sm lg:inline-block">
            Wholesale
          </Link>
          <RegionPreferences />
          <Button nativeButton={false} variant="ghost" size="icon-lg" aria-label="Account" render={<Link href="/account" />}>
            <UserIcon aria-hidden="true" />
          </Button>
          <CartButton />
          <Button variant="ghost" size="icon-lg" aria-label="Search" className="md:hidden">
            <SearchIcon aria-hidden="true" />
          </Button>
        </div>
      </div>
    </header>
  )
}

function Footer() {
  return (
    <footer className="bg-muted/30 mt-16">
      <div className="mx-auto grid w-full max-w-6xl grid-cols-2 gap-8 px-4 py-12 sm:grid-cols-3">
        <div>
          <h3 className="text-sm font-semibold">Shop</h3>
          <ul className="mt-3 flex flex-col gap-2">
            <li><Link href="/products" className="text-muted-foreground hover:text-foreground text-sm">All products</Link></li>
            {CATEGORIES.map((category) => (
              <li key={category.permalink}>
                <Link href={`/c/${category.permalink}`} className="text-muted-foreground hover:text-foreground text-sm">
                  {category.name}
                </Link>
              </li>
            ))}
          </ul>
        </div>

        <div>
          <h3 className="text-sm font-semibold">Account</h3>
          <ul className="mt-3 flex flex-col gap-2">
            <li><Link href="/account" className="text-muted-foreground hover:text-foreground text-sm">My account</Link></li>
            <li><Link href="/account/orders" className="text-muted-foreground hover:text-foreground text-sm">Orders</Link></li>
            <li><Link href="/cart" className="text-muted-foreground hover:text-foreground text-sm">Cart</Link></li>
            <li><Link href="/wholesale" className="text-muted-foreground hover:text-foreground text-sm">Wholesale</Link></li>
          </ul>
        </div>

        <div>
          <h3 className="text-sm font-semibold">Policies</h3>
          <ul className="mt-3 flex flex-col gap-2">
            <li><Link href="/policies/shipping" className="text-muted-foreground hover:text-foreground text-sm">Shipping</Link></li>
            <li><Link href="/policies/returns" className="text-muted-foreground hover:text-foreground text-sm">Returns</Link></li>
            <li><Link href="/policies/privacy" className="text-muted-foreground hover:text-foreground text-sm">Privacy</Link></li>
          </ul>
        </div>
      </div>

      <Separator />
      <p className="text-muted-foreground mx-auto w-full max-w-6xl px-4 py-4 text-xs">© {new Date().getFullYear()} Spree Storefront</p>
    </footer>
  )
}

export default function StorefrontLayout({ children }: PropsWithChildren) {
  return (
    <>
      <Header />
      <main className="flex-1">{children}</main>
      <Footer />
    </>
  )
}
