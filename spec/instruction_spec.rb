require_relative "../lib/instruction"
require_relative "../lib/operand"

class TestInstruction
  def initialize(a, b)
    @opcode = "TEST"
    @modifier = "F"
    @a = a
    @b = b
  end

  # TODO: Mix this in at some point
  def TestInstruction.build(operand_string)
    operands = Instruction.build_operands(operand_string)
    if !operands.nil?
      new(*operands)
    else
      nil
    end
  end
end

#I wonder if this will work...
class TestP < TestInstruction
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
  let(:instruction) { TestInstruction.build("#1234, #4567") }

  it "exposes its guts" do
    expect(instruction.opcode).to eq("TEST")
    expect(instruction.modifier).to eq("F")
    expect(instruction.a).to eq(a)
    expect(instruction.b).to eq(b)
  end

  it "can compare itself to another instruction" do
    newA = Operand.build("#1234")
    newB = Operand.build("#4567")
    # Useful for testing
    expect(instruction).to eq(TestInstruction.new(newA, newB))
    expect(instruction).not_to eq(TestP.new(a, b))
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
