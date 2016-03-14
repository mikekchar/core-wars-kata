require_relative "../../lib/monitor"
require_relative "../fakes/readline"
require_relative "../fakes/io"
require_relative "../../lib/monitor/step"
require_relative "../../lib/add"
require_relative "../setup"

RSpec.describe Step do
  include_context "monitor setup"

  describe "failing command" do
    subject { Step.new("gobbledegook", monitor) }

    it "is not valid" do
      expect(subject).not_to be_valid
    end
  end

  describe "handling case" do
    subject { Step.new("10s", monitor) }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  describe "stepping into a location" do
    let(:location) { 10 }
    subject { Step.new("10S", monitor) }

    it "identifies step commands" do
      expect(subject).to be_valid
    end

    describe "an executable instruction" do
      let(:add) { Add.build("#123, $-1") }

      before(:each) do
        core.store(location, add)
      end

      it "adds a warrior..." do
        expect(mars.warriors.length).to eq(0)
        subject.execute()
        expect(mars.warriors.length).to eq(1)
      end

      it "writes the state of the warriors after execution" do
        subject.execute()
        expect(writer.output).to eq(
          [
            "[0] Warrior 0 added",
            "",
            "Warriors",
            "--------",
            "0 - PC:11"
          ]
        )
      end
    end

    describe "stepping into a DAT" do
      before(:each) do
        subject.execute()
      end

      describe "after executing" do
        it "does not have any warriors left" do
          expect(mars.warriors.length).to eq(0)
        end

        it "writes an empty list of warriors" do
          expect(writer.output).to eq(
            [
              "[0] Warrior 0 added",
              "[0] Warrior 0 killed",
              "",
              "Warriors",
              "--------",
            ]
          )
        end
      end
    end
  end

  describe "continuing" do
    subject { Step.new("S", monitor) }

    it "identifies step commands" do
      expect(subject).to be_valid
    end

    describe "when there are no warriors" do
      before(:each) do
        subject.execute()
      end

      it "writes an empty list of warriors" do
        expect(writer.output).to eq(
          [
            "",
            "Warriors",
            "--------",
          ]
        )
      end
    end
  end
end
