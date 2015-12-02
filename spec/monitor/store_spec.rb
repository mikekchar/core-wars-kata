require_relative "../../lib/monitor"
require_relative "../../lib/core"
require_relative "../fakes/readline"
require_relative "../fakes/io"
require_relative "../../lib/monitor/store"

RSpec.describe Monitor do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  subject { Monitor.new(core, reader, writer) }

  describe "storing a value" do
    let(:location) {16}
    let(:value) {255}

    it "identifies store commands" do
      store = Store.new("10:FF", subject)
      expect(store).to be_valid
    end

    it "stores the value at the location" do
      store = Store.new("10:FF", subject)
      store.execute()
      expect(core.fetch(location)).to eq(value)
    end

    it "stores values at negative locations" do
      store = Store.new("-10:FF", subject)
      store.execute()
      expect(core.fetch(core_size - location)).to eq(value)
    end

    it "does not store negative values" do
      store = Store.new("10:-ff", subject)
      expect(store).not_to be_valid
    end

  end


end
