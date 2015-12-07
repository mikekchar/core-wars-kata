require_relative "../lib/instruction"

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
  end

  # FIXME: Test the opposite

  describe "DAT" do
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
end
