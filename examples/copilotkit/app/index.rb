# frozen_string_literal: true

# DB is opened and migrated in server.rb.
get "/" do
  inertia("index", props: { items: DB.query("select id, title, done from items order by id") })
end

__END__

import { Form, Head, router } from "@inertiajs/react"
import { Check, ListChecks, Trash2 } from "lucide-react"
import { useAgentContext, useFrontendTool } from "@copilotkit/react-core/v2"
import { z } from "zod"

import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Checkbox } from "@/components/ui/checkbox"
import {
  Empty,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"
import { Input } from "@/components/ui/input"
import { Item, ItemActions, ItemContent, ItemMedia, ItemGroup, ItemTitle } from "@/components/ui/item"

export type ListItem = { id: number; title: string; done: number }

// WHAT THIS EXAMPLE IS. The page is an ordinary ratalada page: a server-rendered
// list, a form that POSTs to app/items.rb, buttons that PATCH and DELETE
// app/items/[id].rb. The copilot is three hooks on top of it, and no new
// backend:
//
//   useAgentContext  shares this page's state with the model. It is the only
//                    thing the agent knows -- it cannot see the DOM -- so
//                    whatever the user may ask about has to be in here.
//
//   useFrontendTool  gives the model something to DO. The handler runs in the
//                    browser, so it makes the SAME request the UI makes
//                    (router.post / router.patch) with the user's own session.
//                    No agent-only endpoint, no service account, no second
//                    copy of the business rules on the server.
//
// `webmcp` on a tool is WebMCP: CopilotKit also mirrors it onto
// `document.modelContext`, the browser's own tool registry, so an agent that is
// NOT our chat -- a browser agent or extension -- can discover it by name and
// schema and call the same handler, instead of guessing at the DOM. It needs
// nothing on the server: the handler already runs here. The `annotations` are
// what such an agent reads before deciding to call: `readOnlyHint` for a tool
// that only looks, and it is the ONE thing to get right, because an agent may
// treat a read as safe to try unprompted.
//
// Both are REACT-TREE SCOPED: they exist only while this page is mounted, so
// the agent's toolset is always exactly what the current page can do. Register
// them from the page, as here -- or from the shell for app-wide ones.
export default function Index({ items }: { items: ListItem[] }) {
  const remaining = items.filter((item) => !item.done).length

  useAgentContext({
    description:
      "The list the user is looking at. Each item has an id, a title and done " +
      "(0 or 1). These are the only items that exist -- never invent others.",
    value: { items, remaining },
  })

  // READ-ONLY, AND WHY IT EXISTS. Our own chat reads the list from
  // useAgentContext above, so this tool is not for it: a WebMCP browser agent
  // gets the tools and nothing else, so without this it could change the list
  // without ever being able to read it.
  useFrontendTool({
    name: "listItems",
    description: "List the items, with their ids and whether each is done.",
    parameters: z.object({}),
    webmcp: { annotations: { readOnlyHint: true } },
    handler: async () => JSON.stringify(items),
  })

  useFrontendTool({
    name: "addItem",
    description: "Add an item to the list.",
    parameters: z.object({
      title: z.string().describe("What the item says, e.g. 'Order the timber'."),
    }),
    // No readOnlyHint: it writes.
    webmcp: true,
    handler: async ({ title }) => {
      // The same POST the form below makes. `await` matters: the tool result
      // the model reads should mean "the server took it", not "a request left".
      await new Promise<void>((resolve) =>
        router.post("/items", { title }, { preserveScroll: true, onFinish: () => resolve() }),
      )
      return `Added "${title}".`
    },
  })

  useFrontendTool({
    name: "setItemDone",
    description: "Mark one item done, or put it back to not done. Use an id from the context.",
    parameters: z.object({
      id: z.number().describe("The item's id, from the shared list."),
      done: z.boolean().describe("true to complete it, false to reopen it."),
    }),
    webmcp: true,
    handler: async ({ id, done }) => {
      const item = items.find((candidate) => candidate.id === id)
      // Tell the model it was wrong rather than silently patching nothing: it
      // then re-reads the context instead of repeating the same bad id.
      if (!item) return `No item with id ${id}. The ids are: ${items.map((i) => i.id).join(", ")}.`

      await new Promise<void>((resolve) =>
        router.patch(
          `/items/${id}`,
          { done: done ? 1 : 0 },
          { preserveScroll: true, onFinish: () => resolve() },
        ),
      )
      return `"${item.title}" is now ${done ? "done" : "not done"}.`
    },
  })

  return (
    <main className="mx-auto w-full max-w-xl p-6">
      <Head title="copilotkit" />

      <Card>
        <CardHeader>
          <CardTitle>copilotkit</CardTitle>
          <CardDescription>
            {items.length === 0
              ? "Nothing here yet — add one, or ask the copilot to."
              : `${remaining} of ${items.length} still to do.`}
          </CardDescription>
        </CardHeader>

        <CardContent className="flex flex-col gap-4">
          <Form action="/items" method="post" resetOnSuccess className="flex gap-2">
            {({ processing }) => (
              <>
                <Input name="title" placeholder="What needs doing?" aria-label="New item" />
                <Button type="submit" disabled={processing}>
                  Add
                </Button>
              </>
            )}
          </Form>

          {items.length === 0 ? (
            <Empty>
              <EmptyHeader>
                <EmptyMedia variant="icon">
                  <ListChecks />
                </EmptyMedia>
                <EmptyTitle>No items</EmptyTitle>
                <EmptyDescription>
                  Open the copilot and try: “add buy cement, then mark it done”.
                </EmptyDescription>
              </EmptyHeader>
            </Empty>
          ) : (
            <ItemGroup>
              {items.map((item) => (
                <Item key={item.id} variant="outline" size="sm">
                  <ItemMedia>
                    <Checkbox
                      checked={Boolean(item.done)}
                      aria-label={`Mark "${item.title}" done`}
                      onCheckedChange={(checked) =>
                        router.patch(
                          `/items/${item.id}`,
                          { done: checked ? 1 : 0 },
                          { preserveScroll: true },
                        )
                      }
                    />
                  </ItemMedia>

                  <ItemContent>
                    <ItemTitle className={item.done ? "text-muted-foreground line-through" : ""}>
                      {item.title}
                    </ItemTitle>
                  </ItemContent>

                  <ItemActions>
                    <Button
                      variant="ghost"
                      size="icon-sm"
                      aria-label={`Delete "${item.title}"`}
                      onClick={() => router.delete(`/items/${item.id}`, { preserveScroll: true })}
                    >
                      <Trash2 />
                    </Button>
                  </ItemActions>
                </Item>
              ))}
            </ItemGroup>
          )}
        </CardContent>

        {items.length > 0 && (
          <CardFooter className="justify-between text-muted-foreground">
            <Badge variant="secondary">{remaining} left</Badge>
            <span className="inline-flex items-center gap-1">
              <Check className="size-3.5" /> the copilot sees this list
            </span>
          </CardFooter>
        )}
      </Card>
    </main>
  )
}
