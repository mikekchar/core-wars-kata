class Operand
  IMMEDIATE_RE = /(\S)(-?\d+)/

  attr_reader :mode, :number
  attr_writer :number

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

  def self.build(string)
    matchdata = string.match(IMMEDIATE_RE)
    if matchdata
      mode = matchdata[1]
      address = matchdata[2].to_i(10)
      return Operand.new(mode, address)
    else
      nil
    end
  end

end


