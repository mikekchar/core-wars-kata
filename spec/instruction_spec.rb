require_relative "../lib/instruction"
require_relative "../lib/operand"

RSpec.describe Instruction do
  let(:a) { Operand.build("#1234") }
  let(:b) { Operand.build("#4567") }
  let(:instruction) { Instruction.new("DAT", "F", a, b) }

  it "exposes its guts" do
    expect(instruction.opcode).to eq("DAT")
    expect(instruction.modifier).to eq("F")
    expect(instruction.a).to eq(a)
    expect(instruction.b).to eq(b)
  end

  it "can compare itself to another instruction" do
    newA = Operand.build("#1234")
    newB = Operand.build("#4567")
    # Useful for testing
    expect(instruction).to eq(Instruction.new("DAT", "F", newA, newB))
    expect(instruction).not_to eq(Instruction.new("DAT", "P", a, b))
  end
  
  describe "build_operands" do
    it "builds operands" do
      a = Operand.build("#1234")
      b = Operand.build("#4567")
      operands = Instruction.build_operands("#1234, #4567")
      expect(operands[0]).to eq(a)
      expect(operands[1]).to eq(b)
    end

    it "works with negative numbers" do
      a = Operand.build("#-1234")
      b = Operand.build("#-4567")
      operands = Instruction.build_operands("#-1234, #-4567")
      expect(operands[0]).to eq(a)
      expect(operands[1]).to eq(b)
    end

    it "works with direct mode" do
      a = Operand.build("$-1234")
      b = Operand.build("$-4567")
      operands = Instruction.build_operands("$-1234, $-4567")
      expect(operands[0]).to eq(a)
      expect(operands[1]).to eq(b)
    end
  end
end
