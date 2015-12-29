require_relative "./instruction"

class Add < Instruction
  INSTR_RE = /^ADD\.AB\s+(\S-?\d+,\s*\S-?\d+)\s*$/

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

  def Add.construct(string)
    matchdata = INSTR_RE.match(string)
    return nil if matchdata.nil?

    Add.build(matchdata[1])
  end
end
