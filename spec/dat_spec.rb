require_relative "../lib/dat"
require_relative "../lib/operand"

RSpec.describe Dat do
  let(:a) { Operand.build("#1234") }
  let(:b) { Operand.build("#4567") }
  let(:dat) { Dat.new(a, b) }

  it "exposes its guts" do
    expect(dat.opcode).to eq("DAT")
    expect(dat.modifier).to eq("F")
    expect(dat.a).to eq(a)
    expect(dat.b).to eq(b)
  end

  it "can match the opcode" do
    expect(Dat.match?(dat)).to be(true)
  end
end
