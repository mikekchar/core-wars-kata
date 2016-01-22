require_relative "../lib/core"
require_relative "../lib/dat"
require_relative "../lib/operand"

RSpec.describe Core do
  let(:inst) { Dat.build("#123, #456") }

  let(:size) { 1000 }
  subject { Core.new(size) }

  it "exists" do
    expect(subject).not_to be_nil
  end

  it "has a size" do
    expect(subject.size).to eq(size)
  end

  it "has different instructions in each location" do
    first = subject.fetch(1)
    second = subject.fetch(2)
    expect(first).not_to be(second)
  end

  describe "Storing and fetching instructions" do
    it "stores instructions in the core" do
      subject.store(0, inst)
      expect(subject.fetch(0)).to eq(inst)
    end

    it "returns the instruction it stored" do
      expect(subject.store(0, inst)).to eq(inst)
    end

    it "does not store nil" do
      expect(subject.store(0, nil)).to be_nil
      expect(subject.fetch(0)).not_to be_nil
    end

    it "fetches core(0) for size" do
      subject.store(size, inst)
      expect(subject.fetch(size)).to eq(inst)
      expect(subject.fetch(0)).to eq(inst)
    end

    describe "storing to negative addresses" do
      it "should wrap" do
        subject.store(-1, inst)
        expect(subject.fetch(size - 1)).to eq(inst)
      end
    end

    describe "storing to addresses bigger than size" do
      it "should wrap" do
        subject.store(size + 1, inst)
        expect(subject.fetch(1)).to eq(inst)
      end
    end

    describe "fetching from negative addresses" do
      it "should wrap" do
        subject.store(size - 1, inst)
        expect(subject.fetch(-1)).to eq(inst)
      end
    end
    
    describe "fetching addresses bigger than size" do
      it "should wrap" do
        subject.store(1, inst)
        expect(subject.fetch(size + 1)).to eq(inst)
      end
    end

    it "defaults to having 'DAT.F #0, #0' in the core" do
      expect(subject.fetch(0)).to eq(Dat.build("#0, #0"))
    end
  end
end
