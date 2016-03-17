require_relative "../lib/mars"
require_relative "../lib/core"
require_relative "../lib/dat"
require_relative "../lib/add"

RSpec.describe Mars do
  let(:core) { Core.new(1024) }
  let(:add) { Add.build("#123, $-1") }
  let(:dat) { Dat.build("#0, #0") }
  let(:location) { 10 }

  subject    { Mars.new(core) }

  before do
    subject.store(location, add)
    subject.store(location + 1, add)
    subject.store(location + 2, dat)
  end

  describe "delegation to core" do
    it "delegates address" do
      expect(core).to receive(:address)
      subject.address(123)
    end

    it "delegates store" do
      expect(core).to receive(:store)
      subject.store(123, "fake instruction")
    end

    it "delegates fetch" do
      expect(core).to receive(:fetch)
      subject.fetch(123)
    end
  end

  it "starts with no warriors" do
    expect(subject.warriors).to eq([])
  end

  describe "adding warriors" do
    before do
      subject.addWarrior(location)
    end

    it "increases the number of warriors" do
      expect(subject.warriors.length).to eq(1)
    end

    it "logs the addition" do
      expect(subject.log.to_strings).to eq(
        ["[0] Warrior 0 added", "[0] Task 0 added"]
      )
    end

    it "can add multiple warriors" do
      subject.addWarrior(location)
      expect(subject.warriors.length).to eq(2)
      expect(subject.log.to_strings).to eq([
        "[0] Warrior 0 added", "[0] Task 0 added",
        "[0] Warrior 1 added", "[0] Task 0 added"
      ])
    end
  end

  describe "removing warriors" do
    before do
      subject.addWarrior(location)
      subject.addWarrior(location + 1)
      subject.addWarrior(location + 2)
    end

    it "adds all the warriors" do
      expect(subject.warriors.length).to eq(3)
    end

    it "does not remove live warriors" do
      subject.log.reset()
      subject.removeDeadWarriors()
      expect(subject.warriors.length).to eq(3)
      expect(subject.log.to_strings).to eq([])
    end

    context "after a manual step" do
      before do
        subject.warriors.each { |warrior| warrior.step() }
      end

      it "kills the correct warriors" do
        expect(subject.warriors[0]).not_to be_killed # add instruction
        expect(subject.warriors[1]).not_to be_killed # add instruction
        expect(subject.warriors[2]).to be_killed     # dat instruction
      end

      it "removes the killed warriors" do
        subject.log.reset()
        subject.removeDeadWarriors()
        expect(subject.warriors.length).to eq(2)
        expect(subject.log.to_strings).to eq(
          ["[0] Warrior 2 killed"]
        )
      end
    end

    context "using #step" do
      before do
        subject.log.reset()
        subject.step()
      end

      it "removes the killed warriors" do
        expect(subject.warriors.length).to eq(2)
        expect(subject.log.to_strings).to eq(
          ["[0] Task -1 removed", "[0] Warrior 2 killed"]
        )
      end
    end
  end

  context "using #step" do
    it "starts with a step_num of 0" do
      expect(subject.step_num).to eq(0)
    end

    context "after an initial step into an add" do
      before do
        subject.step(location)
      end

      it "adds a warrior" do
        expect(subject.log.to_strings).to eq(
          ["[0] Warrior 0 added", "[0] Task 0 added"]
        )
      end

      it "increments the step_num" do
        expect(subject.step_num).to eq(1)
      end

      context "adding another warrior" do
        before do
          # Remove the log from the first step
          subject.log.reset()
          subject.step(location)
        end

        it "adds a warrior" do
          expect(subject.log.to_strings).to eq(
            ["[1] Warrior 1 added", "[1] Task 0 added"]
          )
        end

        it "increments the step_num" do
          expect(subject.step_num).to eq(2)
        end
      end

      context "step into another add" do
        before do
          # Remove the log from the first step
          subject.log.reset()
          subject.step()
        end

        it "adds nothing to the log" do
          expect(subject.log.to_strings).to eq([])
        end

        it "increments the step_num" do
          expect(subject.step_num).to eq(2)
        end

        context "step into a dat" do
          before do
            # Remove the log from the first step
            subject.log.reset()
            subject.step()
          end

          it "kills the warrior" do
            expect(subject.log.to_strings).to eq(
              ["[2] Task -1 removed", "[2] Warrior 0 killed"]
            )
          end

          it "increments the step_num" do
            expect(subject.step_num).to eq(3)
          end
        end
      end
    end
  end
end
