class Operand
  attr_reader :mode, :number

  def initialize(mode, number)
    @mode = mode
    @number = number
  end

  def ==(other)
    other.mode == @mode && other.number == @number
  end

  def to_s
    "#{@mode}#{@number}"
  end
end


