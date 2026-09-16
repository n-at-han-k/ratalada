# frozen_string_literal: true

get "/" do
  inertia("index", props: { tasks: tasks })
end

__END__

import { useState } from "react"
import { Form, Head, Link, router } from "@inertiajs/react"
import { ListChecks, Pencil, Plus, Trash2 } from "lucide-react"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import {
  Empty,
  EmptyDescription,
  EmptyHeader,
  EmptyMedia,
  EmptyTitle,
} from "@/components/ui/empty"
import { Input } from "@/components/ui/input"
import {
  Item,
  ItemActions,
  ItemContent,
  ItemGroup,
  ItemMedia,
  ItemTitle,
} from "@/components/ui/item"
import { ToggleGroup, ToggleGroupItem } from "@/components/ui/toggle-group"

export type Task = { id: number; title: string; done: number }

type Filter = "all" | "active" | "done"

export default function Index({ tasks }: { tasks: Task[] }) {
  const [filter, setFilter] = useState<Filter>("all")

  const remaining = tasks.filter((task) => !task.done).length
  const shown = tasks.filter((task) =>
    filter === "all" ? true : filter === "done" ? task.done : !task.done,
  )

  return (
    <main className="mx-auto w-full max-w-xl p-6">
      <Head title="todos" />

      <Card>
        <CardHeader>
          <CardTitle>todos</CardTitle>
          <CardDescription>
            {tasks.length === 0
              ? "Nothing here yet."
              : `${remaining} of ${tasks.length} still to do.`}
          </CardDescription>
          <CardAction>
            <Button variant="outline" nativeButton={false} render={<Link href="/tasks/new" />}>
              <Plus />
              New task
            </Button>
          </CardAction>
        </CardHeader>

        <CardContent className="flex flex-col gap-4">
          {/* The same POST the modal submits — a one-field form needs no dialog. */}
          <Form action="/tasks" method="post" resetOnSuccess className="flex gap-2">
            {({ processing }) => (
              <>
                <Input name="title" placeholder="What needs doing?" aria-label="New task" />
                <Button type="submit" disabled={processing}>
                  Add
                </Button>
              </>
            )}
          </Form>

          {tasks.length === 0 ? (
            <Empty>
              <EmptyHeader>
                <EmptyMedia variant="icon">
                  <ListChecks />
                </EmptyMedia>
                <EmptyTitle>No tasks</EmptyTitle>
                <EmptyDescription>Add the first one above.</EmptyDescription>
              </EmptyHeader>
            </Empty>
          ) : (
            <ItemGroup>
              {shown.map((task) => (
                <Item key={task.id} variant="outline" size="sm">
                  <ItemMedia>
                    <Checkbox
                      checked={Boolean(task.done)}
                      aria-label={`Mark "${task.title}" done`}
                      onCheckedChange={(checked) =>
                        router.patch(
                          `/tasks/${task.id}`,
                          { done: checked ? 1 : 0 },
                          { preserveScroll: true },
                        )
                      }
                    />
                  </ItemMedia>

                  <ItemContent>
                    <ItemTitle className={task.done ? "text-muted-foreground line-through" : ""}>
                      {task.title}
                    </ItemTitle>
                  </ItemContent>

                  <ItemActions>
                    <Button
                      variant="ghost"
                      size="icon-sm"
                      nativeButton={false}
                      aria-label={`Edit "${task.title}"`}
                      render={<Link href={`/tasks/${task.id}/edit`} />}
                    >
                      <Pencil />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon-sm"
                      aria-label={`Delete "${task.title}"`}
                      onClick={() => router.delete(`/tasks/${task.id}`, { preserveScroll: true })}
                    >
                      <Trash2 />
                    </Button>
                  </ItemActions>
                </Item>
              ))}
            </ItemGroup>
          )}
        </CardContent>

        {tasks.length > 0 && (
          <CardFooter className="justify-between">
            <Badge variant="secondary">{remaining} left</Badge>

            <ToggleGroup
              value={[filter]}
              onValueChange={(value) => setFilter((value[0] as Filter) ?? "all")}
              variant="outline"
              size="sm"
              spacing={0}
            >
              <ToggleGroupItem value="all">All</ToggleGroupItem>
              <ToggleGroupItem value="active">Active</ToggleGroupItem>
              <ToggleGroupItem value="done">Done</ToggleGroupItem>
            </ToggleGroup>
          </CardFooter>
        )}
      </Card>
    </main>
  )
}
