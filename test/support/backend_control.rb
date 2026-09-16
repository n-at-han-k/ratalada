# frozen_string_literal: true

module BackendControl
  # Captures what Server.run hands the backend, for specs that then call the
  # app it built.
  def recording_backend
    Class.new do
      attr_reader :app, :host, :port, :count

      def run(app, host:, port:, count:)
        @app = app
        @host = host
        @port = port
        @count = count
      end
    end.new
  end
end

# Tag a group `:backend` to swap Ratalada.backend for this group's `backend`
# and put the original back afterwards. Override `let(:backend)` to install
# something else — including nil, for the no-backend error path.
RSpec.shared_context "with a backend" do
  let(:backend) { recording_backend }

  around do |example|
    original = Ratalada.config.backend
    Ratalada.config.backend = backend
    example.run
  ensure
    Ratalada.config.backend = original
  end
end
