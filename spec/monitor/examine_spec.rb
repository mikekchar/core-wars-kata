require_relative "../../lib/monitor"
require_relative "../fakes/readline"
require_relative "../../lib/monitor/examine"
require_relative "../setup"

RSpec.describe Examine do
  include_context "mars setup"
  let(:reader) { Fake::Readline.new() }
  let(:writer) { logWriter }
  let(:monitor) { Monitor.new(mars, reader, writer) }

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
