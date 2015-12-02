require_relative "../../lib/monitor"
require_relative "../../lib/core"
require_relative "../fakes/readline"
require_relative "../fakes/io"
require_relative "../../lib/monitor/address"

RSpec.describe Monitor do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  subject { Monitor.new(core, reader, writer) }

  describe "reading an address" do
    it "identifies addresses" do
      address = Address.new("1234", subject) 
      expect(address).to be_valid
    end

    it "rejects non-addresses" do
      address = Address.new("hello", subject) 
      expect(address).not_to be_valid
    end

    describe "fetching an address within bounds" do
      it "outputs the value at an address" do
        address = Address.new("10", subject) 
        address.execute()
        expect(writer.output).to eq(["0"])
      end
    end

    describe "fetching an address out of bounds" do
      it "outputs the value" do
        # It is numbered from 0, so core.size is out of bounds
        hex_size = core.size.to_s(16)
        address = Address.new("#{hex_size}", subject) 
        address.execute()
        expect(writer.output).to eq(["0"])
      end

      it "outputs an error message" do
        address = Address.new("-1", subject) 
        address.execute()
        expect(writer.output).to eq(["0"])
      end
    end
  end
end
