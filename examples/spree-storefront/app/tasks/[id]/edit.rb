# frozen_string_literal: true

get "/" do
  found = task(params["id"])

  if found.nil?
    status(404)
    inertia("+not-found")
  else
    render_modal(
      background:       "index",
      background_props: { tasks: tasks },
      component:        "tasks/[id]/edit",
      props:            { task: found },
      url:              "/",
    )
  end
end

patch "/" do
  title = params["title"].to_s.strip

  if title.empty?
    page_errors(title: "Give the task a title")
    redirect("/tasks/#{params['id']}/edit", 303)
  else
    DB.execute("update tasks set title = ? where id = ?", title, params["id"])
    redirect("/", 303)
  end
end

__END__

import { Form, Head } from "@inertiajs/react"

import { Button } from "@/components/ui/button"
import {
  DialogClose,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Field, FieldError, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"

type Task = { id: number; title: string; done: number }

export default function EditTask({ task }: { task: Task }) {
  return (
    <>
      <Head title="Edit task" />

      <Form action={`/tasks/${task.id}/edit`} method="patch" className="contents">
        {({ processing, errors }) => (
          <>
            <DialogHeader>
              <DialogTitle>Edit task</DialogTitle>
            </DialogHeader>

            <FieldGroup>
              <Field>
                <FieldLabel htmlFor="title">Task</FieldLabel>
                <Input id="title" name="title" autoFocus defaultValue={task.title} />
                <FieldError errors={errors.title ? [{ message: errors.title }] : undefined} />
              </Field>
            </FieldGroup>

            <DialogFooter className="gap-2">
              <Button type="submit" disabled={processing}>
                Save
              </Button>
              <DialogClose render={<Button variant="ghost" type="button" />}>Cancel</DialogClose>
            </DialogFooter>
          </>
        )}
      </Form>
    </>
  )
}
