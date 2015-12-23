require_relative "../lib/core"
require_relative "../lib/dat"
require_relative "../lib/operand"

RSpec.describe Core do
  let(:a) { Operand.build("#123") }
  let(:b) { Operand.build("#456") }
  let(:inst) { Dat.new(a, b) }

  let(:size) { 1000 }
  subject { Core.new(size) }

  it "exists" do
    expect(subject).not_to be_nil
  end

  it "has a size" do
    expect(subject.size).to eq(size)
  end

  describe "Storing and fetching instructions" do
    it "stores instructions in the core" do
      subject.store(0, inst)
      expect(subject.fetch(0)).to eq(inst)
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
      a = Operand.build("#0")
      b = Operand.build("#0")
      expect(subject.fetch(0)).to eq(Dat.new(a, b))
    end
  end
end
