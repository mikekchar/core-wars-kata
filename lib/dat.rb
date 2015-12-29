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

  def Dat.build(operand_string)
    operands = Instruction.build_operands(operand_string)
    if !operands.nil?
      Dat.new(*operands)
    else
      nil
    end
  end

  def Dat.construct(string)
    matchdata = INSTR_RE.match(string)
    return nil if matchdata.nil?

    Dat.build(matchdata[1])
  end
end

