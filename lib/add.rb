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

  # TODO: Mix this in at some point
  def Add.build(operand_string)
    operands = Instruction.build_operands(operand_string)
    if !operands.nil?
      new(*operands)
    else
      nil
    end
  end

  def fetchOperands(registers)
    pc = registers.pc
    # FIXME: Hard coding to direct addressing mode
    registers.fetch(pc + @b.number)
  end

  def execute(registers)
    pc = registers.pc
    # FIXME: Hard coding to direct addressing mode
    registers.cache[pc + @b.number].a.number += a.number
  end
end
