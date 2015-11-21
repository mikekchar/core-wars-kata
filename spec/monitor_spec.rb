require_relative "../lib/monitor"
require_relative "../lib/core"
require_relative "fakes/readline"
require_relative "fakes/io"

RSpec.describe Monitor do
  let(:core) { Core.new(1024) }
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

    describe "fetching a valid address" do
      it "outputs the value at an address" do
        subject.inspect_address("10")
        expect(writer.output).to eq(["0"])
      end
    end
    describe "fetching an invalid address" do
      it "outputs an error message" do
        # It is numbered from 0, so core.size is out of bounds
        subject.inspect_address(core.size.to_s)
        expect(writer.output).to eq(["Illegal address: #{core.size}"])
      end

      it "outputs an error message" do
        # It is numbered from 0, so core.size is out of bounds
        subject.inspect_address("-1")
        expect(writer.output).to eq(["Illegal address: -1"])
      end
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
      let(:command1) {"100"}

      before(:each) do
        reader.addInput(command1)
      end
      it "exits upon reading the exit command" do
        subject.process()
        expect(writer.output).to eq(["0"])
      end
    end
  end
end
