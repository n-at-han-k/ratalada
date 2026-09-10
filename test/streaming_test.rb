# frozen_string_literal: true

require "test_helper"
require "socket"
require "ratalada/falcon"
require "async"
require "async/http/client"
require "async/http/endpoint"

# The rest of the suite calls apps in-process, which cannot say anything about
# a connection held open. This one boots falcon for real and reads from it over
# a socket, to prove the two things that make live connections work: chunks
# reach the client as they are produced, and a request parked inside a handler
# does not stop another request from being served.
class StreamingTest < Minitest::Test
  STEPS = 3
  GAP = 0.1

  # An SSE body: rack calls #each and falcon writes every chunk out as it is
  # yielded. The sleep parks this request's fiber, so the worker stays free.
  class Events
    def each
      STEPS.times do |i|
        sleep(GAP)
        yield "data: tick #{i}\n\n"
      end
    end
  end

  def setup
    @port = free_port
    @pid = fork do
      $stderr.reopen(File::NULL, "w")

      Server.run(host: "127.0.0.1", port: @port) do |request|
        case request
        in ["GET", "/events"] then [200, { "content-type" => "text/event-stream" }, Events.new]
        in ["GET", "/ping"]   then "pong"
        end
      end
    end

    wait_until_listening
  end

  def teardown
    Process.kill("TERM", @pid)
    Process.wait(@pid)
  end

  def test_chunks_arrive_as_they_are_produced_and_do_not_block_other_requests
    ticks = []
    ponged_at = nil

    Async do
      client = Async::HTTP::Client.new(endpoint)

      streaming = Async do
        response = client.get("/events")
        response.each { |chunk| ticks << [chunk, elapsed] }
        response.close
      end

      # Mid-stream, over its own connection: the fiber sleeping inside the SSE
      # body must not delay this.
      sleep(GAP * 1.5)
      pong = Async::HTTP::Client.new(endpoint).get("/ping")
      ponged_at = elapsed

      assert_equal "pong", pong.read

      streaming.wait
      client.close
    end

    assert_equal ["data: tick 0\n\n", "data: tick 1\n\n", "data: tick 2\n\n"], ticks.map(&:first)

    # Buffered-until-close would land every chunk at the same instant; each one
    # has to show up a gap after the one before it.
    ticks.each_cons(2) do |(_, before), (_, after)|
      assert_operator after - before, :>=, GAP * 0.8, "chunks arrived in a batch: #{ticks.inspect}"
    end

    assert_operator ponged_at, :<, ticks.last.last, "/ping waited on the open stream"
  end

  private

  def elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  def endpoint = Async::HTTP::Endpoint.parse("http://127.0.0.1:#{@port}")

  def free_port
    TCPServer.open("127.0.0.1", 0) { |server| server.addr[1] }
  end

  def wait_until_listening(timeout: 10)
    deadline = elapsed + timeout

    begin
      TCPSocket.new("127.0.0.1", @port).close
    rescue SystemCallError
      if elapsed > deadline
        raise "falcon never came up on #{@port}"
      end

      sleep(0.05)
      retry
    end
  end
end
