require_relative "../../lib/monitor"
require_relative "../../lib/core"
require_relative "../fakes/readline"
require_relative "../fakes/io"
require_relative "../../lib/monitor/examine"

RSpec.describe Examine do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  let(:monitor) { Monitor.new(core, reader, writer) }

  subject { Examine.new("e", monitor) }

  it "returns nil if it doesn't match" do
    expect(subject.match("store")).to be_nil
  end

  it "prints the list of warriors" do
    subject.execute()
    expect(writer.output).to eq(
      [
        "Warriors",
        "--------"
      ]
    )
  end
end
