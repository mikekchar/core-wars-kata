require_relative "./instruction"

class Dat < Instruction
  # The $ should make it greedy (and possibly slow...)
  # First make it work.  Then make it good.
  # FIXME: operand RE is going to be repeated a lot.
  DAT_RE = /^DAT\.F\s+(\S-?\d+,\s*\S-?\d+)$/

  def initialize(a, b)
    @opcode = "DAT"
    @modifier = "F"
    @a = a
    @b = b
  end

  def Dat.match(command)
    DAT_RE.match(command.upcase())
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

