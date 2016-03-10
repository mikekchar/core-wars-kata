require_relative "../lib/mars"
require_relative "../lib/core"

RSpec.describe Mars do
  let(:core) { Core.new(1024) }
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
    let(:location) { 10 }

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
    it "is pending"
  end
end
