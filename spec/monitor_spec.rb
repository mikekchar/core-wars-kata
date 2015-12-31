require_relative "../lib/monitor"
require_relative "../lib/mars"
require_relative "../lib/dat"
require_relative "fakes/readline"
require_relative "fakes/io"

RSpec.describe Monitor do
  let(:core_size) { 1024 }
  let(:mars) { Mars.new(core_size) }
  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  subject { Monitor.new(mars, reader, writer) }

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
      describe "when there are no executing warriors" do
        let(:command) { "e" }

        before(:each) do
          reader.addInput(command)
          subject.process()
        end

        it "prints an empty list of warriors" do
          expect(writer.output).to eq(
            [
              "Warriors",
              "--------"
            ]
          )
        end
      end

      describe "when there is an actively executing warrior" do
        let(:add)     { "11:ADD.AB #4, $-1" }
        let(:step)    { "11S" }
        let(:examine) { "E" }

        before(:each) do
          reader.addInput(add)
          reader.addInput(step)
          reader.addInput(examine)
          subject.process()
        end

        it "lists the warrior" do
          subject.process()
          expect(writer.output).to eq(
            [
              "Warriors",
              "--------",
              "0 - PC:12"
            ]
          )
        end
      end
    end
  end
end
