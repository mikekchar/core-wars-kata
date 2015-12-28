require_relative "../lib/add"
require_relative "../lib/operand"

RSpec.describe Add do
  let(:a) { Operand.build("#1234") }
  let(:b) { Operand.build("$-1") }
  let(:add) { Add.new(a, b) }

  it "exposes its guts" do
    expect(add.opcode).to eq("ADD")
    expect(add.modifier).to eq("AB")
    expect(add.a).to eq(a)
    expect(add.b).to eq(b)
  end

  it "can match the opcode" do
    expect(Add.match?(add)).to be(true)
  end

  it "can be built from a string" do
    expect(Add.build("#1234,  $-1")).to eq(add)
  end
end
