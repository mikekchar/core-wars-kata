require_relative "./operand"

class Instruction
  OPERANDS_RE = /(\S-?\d+),\s*(\S-?\d+)/
  attr_reader :opcode, :modifier, :a, :b

  # Instruction is an abstract class.  Make sure to set
  # the opcode, modifier, a and b in the derived class's
  # constructor.

  def Instruction.build_operands(string)
    matchdata = OPERANDS_RE.match(string)
    if !matchdata.nil?
      a = Operand.build(matchdata[1])
      b = Operand.build(matchdata[2])
      [a, b]
    else
      nil
    end
  end

  # TODO: Mix this in at some point
  def Instruction.build(operand_string)
    operands = Instruction.build_operands(operand_string)
    if !operands.nil?
      new(*operands)
    else
      nil
    end
  end

  def clone
    # FIXME: This will break when we implement multiple modes
    self.class.build("#{a}, #{b}")
  end

  def ==(other)
    other.opcode == @opcode && other.modifier == @modifier &&
      other.a == @a && other.b == @b
  end

  # The next PC is dependent on the instruction.  Most will
  # simply increment the PC, but jumps will need to do something
  # different.
  def nextPC(registers)
    registers.incrementPC()
  end

  def fetchOperands(registers)
    # Nothing to do in the general case
  end

  def to_s
    "#{@opcode}.#{@modifier} #{@a}, #{@b}"
  end
end
