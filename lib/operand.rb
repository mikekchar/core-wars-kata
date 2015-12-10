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


