# frozen_string_literal: true

post "/" do
  title = params["title"].to_s.strip

  if title.empty?
    page_errors(title: "Give the task a title")
    # Back where the form was: the inline one on the list, or the modal.
    redirect(request.referer || "/tasks/new", 303)
  else
    DB.execute("insert into tasks (title) values (?)", title)
    redirect("/", 303)
  end
end
