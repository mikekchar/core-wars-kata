require_relative "../lib/cache"
require_relative "../lib/add"
require_relative "../lib/dat"
require_relative "setup"

RSpec.describe Cache do
  include_context "mars setup"

  let(:location) { 10 }
  let(:add) { Add.build("#4, $-1") }
  let(:dat) { Dat.build("#0, #0") }
  let(:added_dat) { Dat.build("#4, #0") }
  subject { Cache.new(mars) }

  before(:each) do
    core.store(location, add)
  end

  it "contains nil if we don't fetch anything" do
    expect(subject.inspect(location)).to be_nil
  end

  it "contains instructions that we fetch" do
    subject.fetch(location)
    expect(subject.inspect(location)).to eq(add)
  end

  it "always copies the value" do
    subject.fetch(location)
    expect(subject.inspect(location)).not_to be(add)
  end

  it "writes instructions back to the core" do
    instruction = subject.fetch(location)
    instruction.a.number = 10
    subject.write()
    expect(core.fetch(location)).to eq(Add.build("#10, $-1"))
  end
end
