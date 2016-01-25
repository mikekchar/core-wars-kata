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

  def execute(registers)
    pc = registers.pc
    # FIXME: Hard coding to direct addressing mode
    registers.fetch(pc + @b.number).a.number += a.number
  end
end
