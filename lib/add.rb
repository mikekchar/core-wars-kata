require_relative "./instruction"

class Add < Instruction

  def initialize(a, b)
    @opcode = "ADD"
    @modifier = "AB"
    @a = a
    @b = b
  end

  def Add.match?(instruction)
    instruction.opcode == "ADD"
  end

  def Add.build(operand_string)
    operands = Instruction.build_operands(operand_string)
    if !operands.nil?
      Add.new(*operands)
    else
      nil
    end
  end
end
