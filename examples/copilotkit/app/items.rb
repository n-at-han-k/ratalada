# frozen_string_literal: true

# The app's own routes -- the ones the UI posts to, and the ones the copilot's
# frontend tools post to as well. There is no agent-only API: the tool handler
# runs in the browser and makes the same request a click does, so anything the
# agent can do is something the UI could already do.
post "/" do
  title = params["title"].to_s.strip

  if title.empty?
    page_errors(title: "Give the item a title")
    redirect("/", 303)
  else
    DB.execute("insert into items (title) values (?)", title)
    redirect("/", 303)
  end
end
