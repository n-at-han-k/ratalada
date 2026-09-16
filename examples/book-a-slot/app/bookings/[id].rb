# frozen_string_literal: true

# Cancelling frees the slot: the row is the booking, so deleting it is the
# whole operation.
delete "/" do
  DB.execute("delete from bookings where id = ?", params["id"])
  redirect("/bookings", 303)
end
