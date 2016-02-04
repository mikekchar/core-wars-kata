require_relative "./instruction"

class Dat < Instruction
  # The $ should make it greedy (and possibly slow...)
  # First make it work.  Then make it good.
  # FIXME: operand RE is going to be repeated a lot.
  INSTR_RE = /^DAT\.F\s+(\S-?\d+,\s*\S-?\d+)\s*$/

  def initialize(a, b)
    @opcode = "DAT"
    @modifier = "F"
    @a = a
    @b = b
  end

  def Dat.match?(instruction)
    instruction.opcode == "DAT"
  end

  def execute(registers)
    registers.kill()
  end
end

