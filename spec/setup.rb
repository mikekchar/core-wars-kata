require_relative "../lib/core"
require_relative "../lib/mars"
require_relative "fakes/io"

RSpec.shared_context "mars setup" do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:logWriter) { Fake::IO.new() }
  let(:mars) { Mars.new(core, logWriter) }
end
