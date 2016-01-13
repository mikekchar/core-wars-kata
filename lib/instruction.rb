require_relative "./operand"

class Instruction
  OPERANDS_RE = /(\S-?\d+),\s*(\S-?\d+)/
  attr_reader :opcode, :modifier, :a, :b

  def initialize(opcode, modifier, a, b)
    @opcode = opcode
    @modifier = modifier
    @a = a
    @b = b
  end

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

  def ==(other)
    other.opcode == @opcode && other.modifier == @modifier &&
      other.a == @a && other.b == @b
  end

  # The next PC is dependent on the instruction.  Most will
  # simply increment the PC, but jumps will need to do something
  # different.
  def nextPC(taskState)
    taskState.incrementPC()
  end

  def to_s
    "#{@opcode}.#{@modifier} #{@a}, #{@b}"
  end
end
