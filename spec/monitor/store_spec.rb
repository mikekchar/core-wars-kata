require_relative "../../lib/monitor"
require_relative "../../lib/core"
require_relative "../fakes/readline"
require_relative "../fakes/io"
require_relative "../../lib/monitor/store"
require_relative "../../lib/dat"
require_relative "../../lib/operand"

RSpec.describe Store do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  let(:monitor) { Monitor.new(core, reader, writer) }

  let(:a) { Operand.build("#123") }
  let(:b) { Operand.build("#456") }
  let(:value) { Dat.new(a, b) }

  subject { Store.new("10:DAT.F #123, #456", monitor) }

  describe "storing a value" do
    let(:location) { 10 }

    it "identifies store commands" do
      expect(subject).to be_valid
    end

    it "stores the value at the location" do
      subject.execute()
      expect(core.fetch(location)).to eq(value)
    end

    it "stores values at negative locations" do
      store = Store.new("-10:DAT.F #123, #456", monitor)
      store.execute()
      expect(core.fetch(core_size - location)).to eq(value)
    end

    it "is forgiving of spaces" do
      store = Store.new("10:DAT.F   #123,   #456  ", monitor)
      store.execute()
      expect(core.fetch(location)).to eq(value)
    end

    it "is forgiving of case" do
      store = Store.new("10:dat.f   #123,   #456  ", monitor)
      store.execute()
      expect(core.fetch(location)).to eq(value)
    end

    it "does not store numeric values" do
      store = Store.new("10:123", monitor)
      expect(store).not_to be_valid
    end
  end
end
