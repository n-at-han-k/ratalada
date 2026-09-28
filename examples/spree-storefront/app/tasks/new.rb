# frozen_string_literal: true

# A modal route: the page under it is the list, so the browser gets a whole
# rendered index with the dialog's own component and props alongside it. `url`
# is where closing the dialog navigates back to.
get "/" do
  render_modal(
    background:       "index",
    background_props: { tasks: tasks },
    component:        "tasks/new",
    props:            {},
    url:              "/",
  )
end

__END__

import { Form, Head } from "@inertiajs/react"

import { Button } from "@/components/ui/button"
import {
  DialogClose,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Field, FieldError, FieldGroup, FieldLabel } from "@/components/ui/field"
import { Input } from "@/components/ui/input"

export default function NewTask() {
  return (
    <>
      <Head title="New task" />

      <Form action="/tasks" method="post" className="contents">
        {({ processing, errors }) => (
          <>
            <DialogHeader>
              <DialogTitle>New task</DialogTitle>
              <DialogDescription>It lands at the bottom of the list.</DialogDescription>
            </DialogHeader>

            <FieldGroup>
              <Field>
                <FieldLabel htmlFor="title">Task</FieldLabel>
                <Input id="title" name="title" autoFocus placeholder="Buy oat milk" />
                <FieldError errors={errors.title ? [{ message: errors.title }] : undefined} />
              </Field>
            </FieldGroup>

            <DialogFooter className="gap-2">
              <Button type="submit" disabled={processing}>
                Add task
              </Button>
              <DialogClose render={<Button variant="ghost" type="button" />}>Cancel</DialogClose>
            </DialogFooter>
          </>
        )}
      </Form>
    </>
  )
}
