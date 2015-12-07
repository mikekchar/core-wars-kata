class Operand
  attr_reader :mode, :number

  def initialize(mode, number)
    @mode = mode
    @number = number
  end

  def eql?(other)
    other.mode == @mode && other.number == @number
  end
end

class Instruction
  attr_reader :opcode, :modifier, :a, :b

  def initialize(opcode, modifier, a, b)
    @opcode = opcode
    @modifier = modifier
    @a = a
    @b = b
  end

  def eql?(other)
    other.opcode == @opcode && other.modifier == @modifier &&
      other.a == @a && other.b == @b
  end
end

class Dat < Instruction
  def initialize(a, b)
    @opcode = "DAT"
    @modifier = "F"
    @a = a
    @b = b
  end

  def Dat.match?(instruction)
    instruction.opcode == "DAT"
  end
end
