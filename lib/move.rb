require_relative "./instruction"

class Move < Instruction
  INSTR_RE = /^MOVE\.AB\s+(\S-?\d+,\s*\S-?\d+)\s*$/

  def initialize(a, b)
    @opcode = "MOVE"
    @modifier = "AB"
    @a = a
    @b = b
  end

  def Add.match?(instruction)
    instruction.opcode == "MOVE"
  end

  def execute(registers)
    pc = registers.pc
    # FIXME: Hard coding to indirect addressing mode
    addr = registers.fetch(pc + @b.number)
    target = registers.fetch(addr).b.number
    target.b.number = @a.number
  end
end
