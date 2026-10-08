# frozen_string_literal: true

patch "/" do
  DB.execute("update items set done = ? where id = ?", params["done"].to_i, params["id"])
  redirect("/", 303)
end

delete "/" do
  DB.execute("delete from items where id = ?", params["id"])
  redirect("/", 303)
end
