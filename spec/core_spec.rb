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

    it "should do nothing when storing to an address of size or bigger" do
      subject.store(size, 27)
      expect(subject.fetch(size)).to be_nil
    end

    it "should do nothing when storing to negative addresses" do
      subject.store(-1, 27)
      expect(subject.fetch(-1)).to be_nil
    end
    
    it "defaults to having 0 in the core" do
      # FIXME: Set to specific values at some point
      expect(subject.fetch(0)).to eq(0)
    end

    # We're already testing size.  I could delete this one,
    # but why not have an extra one for size + 1
    it "returns nil for addresses bigger than size" do
      expect(subject.fetch(size + 1)).to be_nil
    end
  end
end
