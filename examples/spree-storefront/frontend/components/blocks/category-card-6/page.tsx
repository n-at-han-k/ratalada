import { CategoryCard } from "./components/category-card"

export function Page() {
  return (
    <div className="bg-background text-foreground flex min-h-svh w-full justify-center p-6 md:p-8">
      <CategoryCard />
    </div>
  )
}