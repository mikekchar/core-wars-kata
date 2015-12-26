require_relative "../lib/monitor"
require_relative "../lib/core"
require_relative "../lib/dat"
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

    describe "examine" do
      let(:command) { "e" }

      before(:each) do
        reader.addInput(command)
      end

      it "exits upon reading the exit command" do
        subject.process()
        expect(writer.output).to eq(
          [
            "Warriors",
            "--------"
          ]
        )
      end
    end
  end
end
