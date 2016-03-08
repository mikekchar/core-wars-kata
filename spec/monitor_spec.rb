require_relative "../lib/monitor"
require_relative "../lib/dat"
require_relative "fakes/readline"
require_relative "fakes/io"
require_relative "setup"

RSpec.describe Monitor do
  include_context "monitor setup"

  describe "reading a single command" do
    let(:command) { "hello" }

    before(:each) do
      reader.addInput(command)
    end

    it "returns the entered command" do
      expect(monitor.read()).to eq("hello")
    end
  end

  describe "event loop" do
    describe "empty input" do
      it "returns no commands" do
        monitor.process()
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
        monitor.process()
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
        monitor.process()
        expect(writer.output).to eq([])
      end
    end

    describe "examine" do
      describe "when there are no executing warriors" do
        let(:command) { "e" }

        before(:each) do
          reader.addInput(command)
          monitor.process()
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
          monitor.process()
          # Clear the output from the previous commands
          writer.reset
          reader.addInput(examine)
          monitor.process()
        end

        it "lists the warrior" do
          monitor.process()
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
