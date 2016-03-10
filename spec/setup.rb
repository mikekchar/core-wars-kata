require_relative "../lib/core"
require_relative "../lib/mars"
require_relative "fakes/io"

RSpec.shared_context "mars setup" do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:mars) { Mars.new(core) }
end

RSpec.shared_context "monitor setup" do
  include_context "mars setup"

  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  let(:monitor) { Monitor.new(mars, reader, writer) }
end
