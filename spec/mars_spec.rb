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
      expect(subject.log.to_strings).to eq([">> Warrior 0 added"])
    end

    it "can add multiple warriors" do
      subject.addWarrior(location)
      expect(subject.warriors.length).to eq(2)
      expect(subject.log.to_strings).to eq([
        ">> Warrior 0 added", ">> Warrior 1 added"
      ])
    end
  end

  describe "removing warriors" do
    before do
      subject.store(location, add)
      subject.store(location + 1, add)
      subject.store(location + 2, dat)
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
        expect(subject.log.to_strings).to eq([">> Warrior 2 killed"])
      end
    end

    context "using #step" do
      before do
        subject.log.reset()
        subject.step()
      end

      it "removes the killed warriors" do
        expect(subject.warriors.length).to eq(2)
        expect(subject.log.to_strings).to eq([">> Warrior 2 killed"])
      end
    end
  end
end
