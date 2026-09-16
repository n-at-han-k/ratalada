# frozen_string_literal: true

# Every frontend wraps its app in plain rack middleware the same way. The
# group supplies `app`; this supplies the assertion.
#
# Grape downcases response header names, hence the `header:` knob.
RSpec.shared_examples "a frontend that runs middleware" do |tag:, header: "X-Middleware"|
  it "runs the middleware around the route" do
    status, headers, body = app.call(env_for("GET", "/"))

    expect(status).to eq(200)
    expect(headers[header]).to eq(tag)
    expect(body).to eq(["ok"])
  end
end
