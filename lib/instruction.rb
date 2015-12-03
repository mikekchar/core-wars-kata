class Instruction
  attr_reader :opcode, :modifier, :a, :b
  def initialize(opcode, modifier, a, b)
    @opcode = opcode
    @modifier = modifier
    @a = a
    @b = b
  end
end
