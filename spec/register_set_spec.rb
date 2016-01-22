require_relative "../lib/register_set"
require_relative "../lib/core"
require_relative "../lib/mars"
require_relative "../lib/add"

RSpec.describe RegisterSet do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:mars) { Mars.new(core) }
  let(:location) { 10 }
  let(:add) { Add.build("#4, $-1") }
  let(:dat) { Dat.build("#0, #0") }
  subject { RegisterSet.new(mars, location) }

  before(:each) do
    core.store(location, add)
  end

  describe "#incrementPC" do
    it "returns the PC + 1" do
      expect(subject.incrementPC()).to eq(location + 1)
    end

    describe "at the end of memory" do
      let(:location) { core_size - 1 }

      it "wraps" do
        expect(subject.incrementPC()).to eq(0)
      end
    end
  end

  describe "caching memory addresses" do
    it "caches the initial address" do
      expect(subject.cache[location]).to eq(add)
    end

    describe "#fetch" do
      let(:new_location) { 5 }

      before(:each) do
        expect(core.fetch(new_location)).to eq(dat)
        core.store(new_location, add)
      end

      it "defaults to nil" do
        expect(subject.cache[new_location]).to be_nil
      end

      it "caches data" do
        expect(subject.fetch(new_location)).to eq(add)
        expect(subject.cache[new_location]).to eq(add)
      end

      it "wraps addresses" do
        expect(subject.fetch(new_location + core_size)).to eq(add)
        expect(subject.cache[new_location]).to eq(add)
      end
    end
  end

  describe "#execute" do
    before(:each) do
      subject.execute()
    end

    it "fetches the instruction into the cache" do
      expect(subject.cache[location]).to eq(add)
    end

    it "fetches the operands into the cache" do
      expect(subject.cache[location - 1]).to eq(dat)
    end
  end
end
