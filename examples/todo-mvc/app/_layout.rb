# frozen_string_literal: true

# A layout is evaluated into every route file below it, so this is where the
# whole app's Sinatra setup lives.
#
# session[:_inertia_errors] is where the render helpers keep validation errors
# between the redirect and the page that shows them.
enable :sessions

helpers Ratalada::Contrib::Vite::TagHelpers
helpers Ratalada::Contrib::Inertia::Helpers

__END__

export { default } from "@/layouts/app-layout"
