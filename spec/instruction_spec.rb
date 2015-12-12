require_relative "../lib/instruction"
require_relative "../lib/operand"

RSpec.describe Instruction do
  let(:a) { Operand.new("#", 1234) }
  let(:b) { Operand.new("#", 4567) }
  let(:instruction) { Instruction.new("DAT", "F", a, b) }

  it "exposes its guts" do
    expect(instruction.opcode).to eq("DAT")
    expect(instruction.modifier).to eq("F")
    expect(instruction.a).to eq(a)
    expect(instruction.b).to eq(b)
  end

  it "can compare itself to another instruction" do
    newA = Operand.new("#", 1234)
    newB = Operand.new("#", 4567)
    # Useful for testing
    expect(instruction).to eq(Instruction.new("DAT", "F", newA, newB))
    expect(instruction).not_to eq(Instruction.new("DAT", "P", a, b))
  end
end
