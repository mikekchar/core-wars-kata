require_relative "../lib/core"

RSpec.describe Core do
  let(:size) { 1000 }
  subject { Core.new(size) }
  it "exists" do
    expect(subject).not_to be_nil
  end

  it "has a size" do
    expect(subject.size).to eq(size)
  end

  describe "Storing and fetching values" do
    it "stores values in the core" do
      subject.store(0, 27)
      expect(subject.fetch(0)).to eq(27)
    end

    it "fetches core(0) for size" do
      subject.store(size, 27)
      expect(subject.fetch(size)).to eq(27)
      expect(subject.fetch(0)).to eq(27)
    end

    describe "storing to negative addresses" do
      it "should wrap" do
        subject.store(-1, 27)
        expect(subject.fetch(size - 1)).to eq(27)
      end
    end

    describe "storing to addresses bigger than size" do
      it "should wrap" do
        subject.store(size + 1, 27)
        expect(subject.fetch(1)).to eq(27)
      end
    end

    describe "fetching from negative addresses" do
      it "should wrap" do
        subject.store(size - 1, 27)
        expect(subject.fetch(-1)).to eq(27)
      end
    end
    
    describe "fetching addresses bigger than size" do
      it "should wrap" do
        subject.store(1, 27)
        expect(subject.fetch(size + 1)).to eq(27)
      end
    end

    it "defaults to having 0 in the core" do
      # FIXME: Set to specific values at some point
      expect(subject.fetch(0)).to eq(0)
    end
  end
end
