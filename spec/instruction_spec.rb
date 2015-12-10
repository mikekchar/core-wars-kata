require_relative "../lib/instruction"
require_relative "../lib/operand"

RSpec.describe Instruction do
  let(:a) { Operand.new("#", 1234) }
  let(:b) { Operand.new("#", 4567) }
  let(:instruction) { Instruction.new("DAT", "F", a, b) }

  it "exposes its guts" do
    expect(instruction.opcode).to eq("DAT")
    expect(instruction.modifier).to eq("F")
    expect(instruction.a).to eql(a)
    expect(instruction.b).to eql(b)
  end

  it "can compare itself to another instruction" do
    # Useful for testing
    expect(instruction).to eql(Instruction.new("DAT", "F", a, b))
    expect(instruction).not_to eql(Instruction.new("DAT", "P", a, b))
  end
end
