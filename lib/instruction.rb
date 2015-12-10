require_relative "./operand"

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
