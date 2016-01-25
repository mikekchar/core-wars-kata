require_relative "../lib/instruction"
require_relative "../lib/operand"

class TestF < Instruction
  def initialize(a, b)
    @opcode = "TEST"
    @modifier = "F"
    @a = a
    @b = b
  end
end

class TestP < Instruction
  def initialize(a, b)
    @opcode = "TEST"
    @modifier = "P"
    @a = a
    @b = b
  end
end

RSpec.describe Instruction do
  let(:a) { Operand.build("#1234") }
  let(:b) { Operand.build("#4567") }
  let(:instruction) { TestF.build("#1234, #4567") }

  it "exposes its guts" do
    expect(instruction.opcode).to eq("TEST")
    expect(instruction.modifier).to eq("F")
    expect(instruction.a).to eq(a)
    expect(instruction.b).to eq(b)
  end

  it "can compare itself to another instruction" do
    # Useful for testing
    expect(instruction).to eq(TestF.build("#1234, #4567"))
    expect(instruction).not_to eq(TestP.build("#1234, #4567"))
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

  describe "#clone" do
    it "makes a copy of the instruction" do
      copy = instruction.clone()
      expect(copy).to eq(instruction)
    end
  end
end
