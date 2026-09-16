# frozen_string_literal: true

# A layout is evaluated into every route file below it, so this is where the
# whole app's Sinatra setup lives.
#
# session[:_inertia_errors] is where the render helpers keep validation errors
# between the redirect and the page that shows them.
enable :sessions

helpers Ratalada::Contrib::Vite::TagHelpers
helpers Ratalada::Contrib::Inertia::Helpers

helpers do
  def bookings
    DB.query("select id, date, time, name, email from bookings order by date, time")
  end

  # date => taken times. The client greys those slots out; the unique index
  # is what actually stops a double booking.
  def booked
    DB.query("select date, time from bookings")
      .group_by { it[:date] }
      .transform_values { |rows| rows.map { it[:time] } }
  end

  # Weekdays in the window that still have a free slot.
  def available_dates(taken = booked)
    (0..BOOKING_WINDOW).filter_map do |offset|
      date = Date.today + offset
      next if date.saturday? || date.sunday?

      key = date.to_s
      key if (SLOT_TIMES - taken.fetch(key, [])).any?
    end
  end

  def bookable?(date, time)
    SLOT_TIMES.include?(time) && available_dates.include?(date)
  end
end

# The page shell. `inertia` renders this once per full page load; every
# navigation after it is the client's, off the page object below.
template :layout do
  <<~ERB
    <!doctype html>
    <html>
      <head>
        <meta charset=utf-8>
        <meta name=viewport content="width=device-width,initial-scale=1">
        <title>book-a-slot</title>
        <%= vite_client_tag %>
        <%= vite_react_refresh_tag %>
        <%= vite_javascript_tag "application.tsx" %>
      </head>
      <body>
        <!-- The Inertia page object, in the script element @inertiajs/* v3
             reads it from (the data-page attribute form is v2). The client
             mounts the component named in it: the TSX after __END__ in that
             app/*.rb. -->
        <script data-page="app" type="application/json"><%= JSON.generate(@page).gsub("/", "\\\\/") %></script>
        <div id="app"></div>
      </body>
    </html>
  ERB
end

__END__

export { default } from "@/layouts/app-layout"
