require_relative "./instruction"

class Dat < Instruction

  def initialize(a, b)
    @opcode = "DAT"
    @modifier = "F"
    @a = a
    @b = b
  end

  def Dat.match?(instruction)
    instruction.opcode == "DAT"
  end

  def Dat.build(operand_string)
    operands = Instruction.build_operands(operand_string)
    if !operands.nil?
      Dat.new(*operands)
    else
      nil
    end
  end
end

