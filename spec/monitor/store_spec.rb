require_relative "../../lib/monitor"
require_relative "../../lib/core"
require_relative "../fakes/readline"
require_relative "../fakes/io"
require_relative "../../lib/monitor/store"
require_relative "../../lib/dat"
require_relative "../../lib/add"
require_relative "../../lib/operand"

RSpec.describe Store do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  let(:monitor) { Monitor.new(core, reader, writer) }

  describe "failing command" do
    let(:location) { 10 }
    let(:default) { Dat.build("#0, #0") }
    subject { Store.new("10:gobbledegook", monitor) }

    it "does not overwrite the default" do
      subject.execute()
      expect(core.fetch(location)).to eq(default)
    end
  end

  describe "storing a DAT" do
    let(:location) { 10 }
    let(:dat) { Dat.build("#123, #456") }
    subject { Store.new("10:DAT.F #123, #456", monitor) }

    it "identifies store commands" do
      expect(subject).to be_valid
    end

    it "stores the DAT at the location" do
      subject.execute()
      expect(core.fetch(location)).to eq(dat)
    end

    it "stores values at negative locations" do
      store = Store.new("-10:DAT.F #123, #456", monitor)
      store.execute()
      expect(core.fetch(core_size - location)).to eq(dat)
    end

    it "is forgiving of spaces" do
      store = Store.new("10:DAT.F   #123,   #456  ", monitor)
      expect(store).to be_valid()
      store.execute()
      expect(core.fetch(location)).to eq(dat)
    end

    it "is forgiving of case" do
      store = Store.new("10:dat.f #123, #456", monitor)
      store.execute()
      expect(core.fetch(location)).to eq(dat)
    end
  end

  describe "storing an ADD" do
    let(:location) { 10 }
    let(:add) { Add.build("#123, $-1") }
    subject { Store.new("10:ADD.AB #123, $-1", monitor) }

    it "identifies store commands" do
      expect(subject).to be_valid
    end

    it "stores the ADD at the location" do
      subject.execute()
      expect(core.fetch(location)).to eq(add)
    end
  end
end
