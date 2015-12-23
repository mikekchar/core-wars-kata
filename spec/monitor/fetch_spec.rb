require_relative "../../lib/monitor"
require_relative "../../lib/core"
require_relative "../fakes/readline"
require_relative "../fakes/io"
require_relative "../../lib/monitor/fetch"

RSpec.describe Monitor do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  subject { Monitor.new(core, reader, writer) }

  describe "reading an address" do
    it "identifies addresses" do
      fetch = Fetch.new("1234", subject) 
      expect(fetch).to be_valid
    end

    it "rejects non-addresses" do
      fetch = Fetch.new("hello", subject) 
      expect(fetch).not_to be_valid
    end

    describe "fetching an address within bounds" do
      it "outputs the value at an address" do
        fetch = Fetch.new("10", subject) 
        fetch.execute()
        expect(writer.output).to eq(["10:DAT.F #0, #0"])
      end
    end

    describe "fetching an address out of bounds" do
      it "wraps to zero" do
        # It is numbered from 0, so core.size is out of bounds
        fetch = Fetch.new("#{core.size}", subject) 
        fetch.execute()
        expect(writer.output).to eq(["0:DAT.F #0, #0"])
      end

      it "wraps to size -x for negative numbers" do
        fetch = Fetch.new("-1", subject) 
        fetch.execute()
        expect(writer.output).to eq(["#{core.size - 1}:DAT.F #0, #0"])
      end
    end
  end
end
