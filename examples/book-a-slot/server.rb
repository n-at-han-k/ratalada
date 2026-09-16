# frozen_string_literal: true

require "date"
require "extralite"

require "ratalada/falcon"
require "ratalada/contrib/vite"
require "ratalada/contrib/inertia"
require "ratalada/contrib/router/file_based/sinatra_adapter"

# The one thing being booked. A real app reads this from a table; an example
# with a single host reads it from a constant.
HOST = {
  name:     "Sarah Chen",
  role:     "Lead Product Designer",
  avatar:   "https://images.unsplash.com/photo-1519699047748-de8e457a634e?w=96&h=96&dpr=2&q=80",
  title:    "Strategy Session",
  platform: "Zoom",
  duration: 30,
}.freeze

# The working day, in the host's timezone. Half-hour slots, lunch at noon.
SLOT_TIMES = (9..17).flat_map { |h| ["%02d:00" % h, "%02d:30" % h] }
  .then { |times| times - ["12:00", "12:30", "17:30"] }
  .freeze

# How far ahead the calendar takes bookings.
BOOKING_WINDOW = 60

DB = Extralite::Database.new(
  File.expand_path("config/database.sqlite", __dir__)
)

# One row per booked slot. The unique index is the double-booking guard: two
# people confirming the same time race in the database, not in Ruby.
DB.execute(<<~SQL)
  create table if not exists bookings (
    id integer primary key,
    date text not null,
    time text not null,
    name text not null,
    email text not null,
    unique (date, time)
  )
SQL

Server
  .use(Ratalada::Contrib::Inertia::JsonParamsMiddleware)
  .use(Ratalada::Contrib::Vite::DevServerProxy)
  .use(Ratalada::Contrib::Inertia::Middleware)
  .use(Ratalada::Contrib::Inertia::CSRFMiddleware)
  .run do
    Ratalada::Contrib::Router::FileBased
      .mount(self, File.expand_path("app", __dir__))
  end
