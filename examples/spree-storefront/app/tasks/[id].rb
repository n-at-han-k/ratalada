# frozen_string_literal: true

patch "/" do
  DB.execute("update tasks set done = ? where id = ?", params["done"].to_i, params["id"])
  redirect("/", 303)
end

delete "/" do
  DB.execute("delete from tasks where id = ?", params["id"])
  redirect("/", 303)
end
