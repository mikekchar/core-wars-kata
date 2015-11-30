require_relative "../lib/monitor"
require_relative "../lib/core"
require_relative "fakes/readline"
require_relative "fakes/io"

RSpec.describe Monitor do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  subject { Monitor.new(core, reader, writer) }

  describe "reading a single command" do
    let(:command) { "hello" }

    before(:each) do
      reader.addInput(command)
    end

    it "returns the entered command" do
      expect(subject.read()).to eq("hello")
    end
  end

  describe "reading an address" do
    it "identifies addresses" do
      expect(subject.address?("1234")).to be true
    end

    it "rejects non-addresses" do
      expect(subject.address?("hello")).to be false
    end

    describe "fetching an address within bounds" do
      it "outputs the value at an address" do
        subject.inspect_address("10")
        expect(writer.output).to eq(["0"])
      end
    end

    describe "fetching an address out of bounds" do
      it "outputs the value" do
        # It is numbered from 0, so core.size is out of bounds
        hex_size = core.size.to_s(16)
        subject.inspect_address(hex_size)
        expect(writer.output).to eq(["0"])
      end

      it "outputs an error message" do
        subject.inspect_address("-1")
        expect(writer.output).to eq(["0"])
      end
    end
  end

  describe "storing a value" do
    let(:command) {"10:FF"}
    let(:location) {16}
    let(:value) {255}

    it "identifies store commands" do
      expect(subject.store?(command)).to be true
    end

    it "stores the value at the location" do
      subject.store_value(command)
      expect(core.fetch(location)).to eq(value)
    end

    it "stores values at negative locations" do
      subject.store_value("-10:ff")
      expect(core.fetch(core_size - location)).to eq(value)
    end

    it "does not store negative values" do
      subject.store_value("10:-ff")
      expect(core.fetch(location)).to eq(0)
      expect(writer.output).to eq(["Illegal store command: 10:-ff"])
    end

  end

  describe "event loop" do
    describe "empty input" do
      it "returns no commands" do
        subject.process()
        expect(writer.output).to be_empty
      end
    end

    describe "input" do
      let(:command1) {"hello"}
      let(:command2) {"world"}

      before(:each) do
        reader.addInput(command1)
        reader.addInput(command2)
      end

      it "reads all of the commands in the input" do
        subject.process()
        expect(writer.output).to eq(
          [
            "Unknown command: hello",
            "Unknown command: world"
          ])
      end
    end

    describe "exiting" do
      let(:command1) {"exit"}
      let(:command2) {"should not get here"}

      before(:each) do
        reader.addInput(command1)
        reader.addInput(command2)
      end

      it "exits upon reading the exit command" do
        subject.process()
        expect(writer.output).to eq([])
      end
    end

    describe "reading an address" do
      describe "addresses are in hexadecimal" do
        let(:command1) {"10"}
        let(:location) {16}
        let(:value) {16}

        before(:each) do
          core.store(location, value)
          reader.addInput(command1)
        end

        it "accesses decimal 16 for addr=10" do
          subject.process()
          expect(writer.output).to eq(["10"])
        end
      end

      describe "addresses are in hexadecimal" do
        let(:command1) { "-10" }
        let(:location) { core_size - 16 }
        let(:value) { 16 }

        before(:each) do
          core.store(location, value)
          reader.addInput(command1)
        end

        it "accesses core_size - 16" do
          subject.process()
          expect(writer.output).to eq(["10"])
        end
      end

    end

    describe "storing an address" do
      let(:command) {"10:FF"}
      let(:location) {16}
      let(:value) {255}

      before(:each) do
        reader.addInput(command)
      end

      it "stores the value" do
        subject.process()
        expect(writer.output).to eq([])
        expect(core.fetch(location)).to eq(value)
      end
    end
  end
end
